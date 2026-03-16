return {
  "abhsss96/notes-nvim",
  lazy = true,
  cmd = { "Note", "NoteToday", "NoteIndex", "NoteFind", "NoteFindAll", "NoteGrep", "NoteRename", "NoteBrowse" },
  keys = { { "<leader>n" } },
  opts = {
    notes_dir = "~/notes",
    note_extension = ".md",
    open_mode = "edit",
    picker = "auto",
  },
}
