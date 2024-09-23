return {
  "echasnovski/mini.starter",
  opts = function()
    local logo = table.concat({
      "                   ██╗  ██╗██╗  ███╗  ██╗███████╗██╗██╗                        ",
      "                   ██║  ██║██║  ████╗ ██║██╔════╝██║██║                        ",
      "                   ███████║██║  ██╔██╗██║█████╗  ██║██║                        ",
      "                   ██╔══██║██║  ██║╚████║██╔══╝  ██║██║                        ",
      "                   ██║  ██║██║  ██║ ╚███║███████╗██║███████╗                   ",
      "                   ╚═╝  ╚═╝╚═╝  ╚═╝  ╚══╝╚══════╝╚═╝╚══════╝,                 ",
      "       It's ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z",
      "            ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    ",
      "            ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       ",
      "            ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         ",
      "            ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           ",
      "            ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           ",
    }, "\n")
    local pad = string.rep(" ", 22)
    local new_section = function(name, action, section)
      return { name = name, action = action, section = pad .. section }
    end

    local starter = require("mini.starter")
    --stylua: ignore
    local config = {
      evaluate_single = true,
      header = logo,
      items = {
        new_section("f Find file",       LazyVim.pick(),                        "Fzf"),
        new_section("n New file",        "ene | startinsert",                   "Built-in"),
        new_section("r Recent files",    LazyVim.pick("oldfiles"),              "Fzf"),
        new_section("g Find text",       LazyVim.pick("live_grep"),             "Fzf"),
        new_section("c Config",          LazyVim.pick.config_files(),           "Config"),
        new_section("s Restore session", [[lua require("persistence").load()]], "Session"),
        new_section("l Lazy",            "Lazy",                                "Config"),
        new_section("x Lazy Extras",     "LazyExtras",                          "Config"),
        new_section("q Quit",            "qa",                                  "Built-in"),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(pad .. "░ ", false),
        starter.gen_hook.aligning("center", "center"),
      },
    }
    return config
  end,
}
