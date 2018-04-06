# Semantics of Vim wrt Viper

## Abstract

Viper shares much between itself and Vim.
This documents attempts to explain the latter to further iinform the design of
the former.

## Count semantics

### o - Open line

The command '5o' creates insert mode and
after returning to normal mode, replicates it 5 times under the current line.
`
## 5i works like 5o

The command '5i' graps the text from the insert buffer
and repreats it in place.

