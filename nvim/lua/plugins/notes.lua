return {
  "abhsss96/notes-nvim",
  lazy = true,
  cmd = { "Note", "NoteToday", "NoteIndex", "NoteFind", "NoteFindAll", "NoteGrep", "NoteRename", "NoteBrowse" },
  opts = {
    notes_dir = "~/notes",
    note_extension = ".md",
    open_mode = "edit",
    picker = "auto",
  },
}
