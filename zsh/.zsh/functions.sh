# --- Configuration des répertoires de notes (assure que c'est défini) ---
export NOTES_DIR="${NOTES_DIR:-$HOME/SynologyDrive/notes}"
export TEMPLATES_DIR="${TEMPLATES_DIR:-$HOME/.templates/notes}"

# --- fzf Note (fnote) ---
fnote() {
    local notes_root="${NOTES_DIR}"
    local templates_root="${TEMPLATES_DIR}"
    mkdir -p "$notes_root" "$templates_root" # Assure que les dossiers existent

    local note_types=(
        "daily:$notes_root/daily"
        "project:$notes_root/projects"
        "topic:$notes_root/topics"
        "scratchpad:$notes_root/scratchpad"
        "collab:$notes_root/collab" 
    )

    local initial_query="$1"

    local existing_notes=$(find "$notes_root" -type f -name "*.md" 2>/dev/null | sed "s|^$notes_root/||")

    local selected_path_and_key=$(echo "$existing_notes" | \
                                   fzf --ansi \
                                       --query="$initial_query" \
                                       --prompt="[NOTES] Open existing or type new name: " \
                                       --preview="bat --color=always --line-range :500 $notes_root/{}" \
                                       --preview-window 'right:50%' \
                                       --expect=ctrl-t,ctrl-x,ctrl-v,alt-n)

    local fzf_exit_code=$?
    local selected_name=$(echo "$selected_path_and_key" | tail -1)
    local key_pressed=$(echo "$selected_path_and_key" | head -1)

    if [[ -z "$selected_name" && "$key_pressed" != "alt-n" ]]; then
        return 1
    fi

    local full_path=""

    if [[ -n "$selected_name" && "$key_pressed" != "alt-n" ]]; then
        full_path="$notes_root/$selected_name"
    else
        local new_note_base_name=""
        if [[ "$key_pressed" == "alt-n" ]]; then
            new_note_base_name=$(echo "$selected_path_and_key" | tail -1)
        else
            new_note_base_name="$selected_name"
        fi

        if [[ -z "$new_note_base_name" ]]; then
            read -r -p "New note name (e.g. 'my-awesome-idea'): " new_note_base_name
            if [[ -z "$new_note_base_name" ]]; then return 1; fi
        fi

        local type_choice=$(printf "%s\n" "${note_types[@]%%:*}" | fzf --prompt="[NOTES] Choose note type: ")
        if [[ -z "$type_choice" ]]; then return 1; fi

        local target_dir=""
        if [[ "$type_choice" == "project" || "$type_choice" == "collab" ]]; then
            local parent_dir="${notes_root}/$(basename "${type_choice}s")" # /projects ou /collab
            mkdir -p "$parent_dir"
            local existing_children=$(find "$parent_dir" -maxdepth 1 -mindepth 1 -type d -printf "%P\n" 2>/dev/null)
            local child_choice_path=$(echo "$existing_children" | \
                                      fzf --ansi --prompt="[$(echo "$type_choice" | tr '[:lower:]' '[:upper:]')] Select existing or type new: ")

            if [[ -z "$child_choice_path" ]]; then
                read -r -p "New $(echo "$type_choice" | tr '[:lower:]' '[:upper:]') name (e.g., client_alpha/projet_phoenix or CollabName): " child_choice_path
                if [[ -z "$child_choice_path" ]]; then return 1; fi
            fi
            target_dir="${parent_dir}/${child_choice_path}"
        else
            for type_def in "${note_types[@]}"; do
                if [[ "${type_def%%:*}" == "$type_choice" ]]; then
                    target_dir="${type_def##*:}"
                    break
                fi
            done
        fi

        local current_date=$(date +%Y-%m-%d)
        local final_name="${current_date}-${new_note_base_name}.md"
        if [[ "$type_choice" == "daily" ]]; then
            final_name="${current_date}.md"
        fi
        if [[ "$type_choice" == "collab" ]]; then # For collab notes, just the name without date prefix
            final_name="${new_note_base_name}.md"
        fi

        full_path="$target_dir/$final_name"
        mkdir -p "$target_dir"

        local template_to_use="$templates_root/$type_choice.md"
        if [ -f "$template_to_use" ]; then
            cp "$template_to_use" "$full_path"
            sed -i "s/YYYY-MM-DD/$current_date/g" "$full_path"
            if [[ "$type_choice" == "collab" ]]; then
                sed -i "s/\[Nom Collaborateur\]/$new_note_base_name/g" "$full_path" # Customize template
            fi
        else
            echo "# $new_note_base_name" > "$full_path"
            echo "Créée le $current_date." >> "$full_path"
        fi

        echo "Created new note: $full_path"
    fi

    if [ -n "$TMUX" ]; then
        case "$key_pressed" in
            "ctrl-t") tmux split-window -h "$EDITOR \"$full_path\""; return 0;;
            "ctrl-x") tmux split-window -v "$EDITOR \"$full_path\""; return 0;;
            "ctrl-v") tmux new-window -n "$(basename "$full_path" .md)" "$EDITOR \"$full_path\""; return 0;;
        esac
    fi

    "$EDITOR" "$full_path"
}
alias n='fnote'

# --- Daily Note (ndaily) ---
ndaily() {
    local daily_note_path="${NOTES_DIR}/daily/$(date +%Y-%m-%d).md"
    mkdir -p "${NOTES_DIR}/daily"
    if [ ! -f "$daily_note_path" ]; then
        local template_to_use="${TEMPLATES_DIR}/daily.md"
        if [ -f "$template_to_use" ]; then
            cp "$template_to_use" "$daily_note_path"
            sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/g" "$daily_note_path"
        else
            echo "# Notes du $(date +%Y-%m-%d)" > "$daily_note_path"
            echo -e "\n## Tâches\n- [ ]\n\n## Journal" >> "$daily_note_path"
        fi
    fi

    if [ -n "$TMUX" ]; then
        if ! tmux list-windows -F '#{window_name}' | grep -q "Daily-$(date +%m%d)"; then
            tmux new-window -n "Daily-$(date +%m%d)" sh -c "$EDITOR \"$daily_note_path\""
        else
            tmux select-window -t "Daily-$(date +%m%d)" # Switch if exists
        fi
    else
        "$EDITOR" "$daily_note_path"
    fi
}
alias nd="ndaily"

# --- TODOs (ntodo) ---
ntodo() {
    local notes_root="${NOTES_DIR}"
    local search_pattern='(TODO|FIXME|\[ \])(?: \(P([1-3])\))?'

    echo "Searching for TODOs with priorities in '$notes_root'..."

    rg --ignore-case --color=always --line-number --type md "$search_pattern" "$notes_root" | \
        while IFS=: read -r file line_num _ line_content; do
            local priority="P4"
            if [[ "$line_content" =~ '\(P([1-3])\)' ]]; then
                priority="P${BASH_REMATCH[1]}"
            fi
            echo "$priority | $file:$line_num:$line_content"
        done | \
        fzf --ansi \
            --tiebreak=index \
            --no-sort \
            --preview-window 'right:50%' \
            --prompt="[TODOs (P1-3, P4=no prio)] Filter or type: " \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --delimiter ':' \
            --nth '2..' \
            --expect=ctrl-t,ctrl-x,ctrl-v \
            --header="Prio | File:Line:Content (Filter P1, P2, P3 or P4 for no priority)" \
            --bind "alt-1:change-query(P1)" \
            --bind "alt-2:change-query(P2)" \
            --bind "alt-3:change-query(P3)" \
            --bind "alt-4:change-query(P4)" \
            --bind "alt-0:change-query()" | while read -r selected_and_key; do

        local key_pressed=$(echo "$selected_and_key" | head -1)
        local selected_line=$(echo "$selected_and_key" | tail -1)

        if [[ -z "$selected_line" ]]; then break; fi

        local processed_line=$(echo "$selected_line" | sed -E 's/^P[1-4] \| //')

        local file_path=$(echo "$processed_line" | awk -F: '{print $1}')
        local line_num=$(echo "$processed_line" | awk -F: '{print $2}')

        if [ -n "$TMUX" ]; then
            case "$key_pressed" in
                "ctrl-t") tmux split-window -h "$EDITOR +${line_num} \"${file_path}\"";;
                "ctrl-x") tmux split-window -v "$EDITOR +${line_num} \"${file_path}\"";;
                "ctrl-v") tmux new-window -n "TODO_Item" "$EDITOR +${line_num} \"${file_path}\"";;
                *) "$EDITOR" +${line_num} "$file_path";;
            esac
        else
            "$EDITOR" +${line_num} "$file_path"
        fi
    done
}

# --- Notes Ripgrep (nrg) ---
nrg() {
    local search_query="$*"
    if [ -z "$search_query" ]; then
        read -r -p "Search in notes (ripgrep + fzf): " search_query
        if [ -z "$search_query" ]; then return 1; fi
    fi

    (cd "$NOTES_DIR" && rg --color=always --line-number --no-heading --smart-case "${search_query}" | \
        fzf --ansi \
            --tiebreak=index \
            --no-sort \
            --preview-window 'right:50%' \
            --prompt="Ripgrep + FZF: " \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --delimiter ':' \
            --nth '1,2,3' \
            --expect=ctrl-t,ctrl-x,ctrl-v \
            --bind "change:reload(rg --color=always --line-number --no-heading --smart-case {q} || true)" | while read -r selected_and_key; do

        local key_pressed=$(echo "$selected_and_key" | head -1)
        local selected_line=$(echo "$selected_and_key" | tail -1)

        if [[ -z "$selected_line" ]]; then break; fi

        local file_path=$(echo "$selected_line" | awk -F: '{print $1}')
        local line_num=$(echo "$selected_line" | awk -F: '{print $2}')

        if [ -n "$TMUX" ]; then
            case "$key_pressed" in
                "ctrl-t") tmux split-window -h "$EDITOR +${line_num} \"${file_path}\"";;
                "ctrl-x") tmux split-window -v "$EDITOR +${line_num} \"${file_path}\"";;
                "ctrl-v") tmux new-window -n "RG_Result" "$EDITOR +${line_num} \"${file_path}\"";;
                *) "$EDITOR" +${line_num} "$file_path";;
            esac
        else
            "$EDITOR" +${line_num} "$file_path"
        fi
    done)
}

# --- Notes Backlinks (nbk) ---
nbk() {
    if [ -z "$1" ]; then
        echo "Usage: nbk <note_filename_without_extension>"
        return 1
    fi
    local note_name="$1"
    local search_pattern="\[\[${note_name}\]\]"

    echo "Searching for backlinks to '[[${note_name}]]' in $NOTES_DIR..."
    rg -i "$search_pattern" "$NOTES_DIR" --with-filename --line-number | \
        fzf --ansi \
            --preview="bat --color=always --highlight-line {2} {1}" \
            --delimiter ':' \
            --nth '1,2,3' \
            --prompt="[Backlinks] Select to open: " \
            --expect=ctrl-t,ctrl-x,ctrl-v | while read -r selected_and_key; do
        local key_pressed=$(echo "$selected_and_key" | head -1)
        local selected=$(echo "$selected_and_key" | tail -1)
        if [[ -z "$selected" ]]; then break; fi

        local file_path=$(echo "$selected" | awk -F: '{print $1}')
        local line_num=$(echo "$selected" | awk -F: '{print $2}')

        if [ -n "$TMUX" ]; then
            case "$key_pressed" in
                "ctrl-t") tmux split-window -h "$EDITOR +${line_num} \"${file_path}\"";;
                "ctrl-x") tmux split-window -v "$EDITOR +${line_num} \"${file_path}\"";;
                "ctrl-v") tmux new-window -n "Backlink" "$EDITOR +${line_num} \"${file_path}\"";;
                *) "$EDITOR" +${line_num} "$file_path";;
            esac
        else
            "$EDITOR" +${line_num} "$file_path"
        fi
    done
}
