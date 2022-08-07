ln -s /path/to/original /path/to/symlink

AstroVim:
(to enable user configs, copy ~/.config/nvim/lua/user_example to ~/.config/nvim/lua/user and create plugins dir inside)
ln -s $HOME/code/configs/nvim/lua/user/plugins/neo-tree.lua $HOME/.config/nvim/lua/user/plugins/neo-tree.lua
ln -s $HOME/code/configs/nvim/lua/user/init.lua $HOME/.config/nvim/lua/user/init.lua
