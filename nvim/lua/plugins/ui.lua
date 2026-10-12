return {
  -- Enabled as a LazyVim extra (see lazyvim.json); these are just your tweaks.
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      hide_target_hack = false,
    },
  },

  -- LazyVim draws icons with mini.icons (nvim-web-devicons is only a shim), so overrides go here.
  -- Entries without `glyph` keep the built-in icon and only recolour it. Neon* groups: colorscheme.lua.
  {
    "nvim-mini/mini.icons",
    opts = {
      extension = {
        ts = { hl = "NeonCyan" },
        tsx = { glyph = "\u{e628}", hl = "NeonCyan" },
        js = { hl = "NeonYellow" },
        jsx = { glyph = "\u{e625}", hl = "NeonYellow" },
        json = { glyph = "\u{e60b}", hl = "NeonTeal" },
        toml = { glyph = "\u{e6b2}", hl = "NeonTeal" },
        yaml = { glyph = "\u{e6a8}", hl = "NeonTeal" },
        md = { glyph = "\u{f48a}", hl = "NeonOrange" },
        txt = { hl = "NeonOrange" },
        lock = { glyph = "\u{f023}", hl = "NeonPurple" },
        lua = { hl = "NeonPink" },
        c = { glyph = "\u{e61e}", hl = "NeonRed" },
        cpp = { glyph = "\u{e61d}", hl = "NeonRed" },
      },
      file = {
        ["pnpm-lock.yaml"] = { hl = "NeonPurple" },
      },
    },
  },
}
