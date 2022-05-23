package fzf

#keybind: {
	key:    #key
	action: #action
}
#key:           "a" | "b" | "c"
#action:        "abort" | "accept" | "accept-nonempty" | "backward-char" | "backward-delete-char" | "backward-delete-char/eof" | "backward-kill-word" | "backward-word" | "beginning-of-line" | "cancel" | "change-preview" | "clear-screen" | "clear-selection" | "close" | "clear-query" | "delete-char" | "delete-char/eof"
#commandAction: "change-preview" | "change-preview-window" | "change-prompt"
test:           #key & "a"
