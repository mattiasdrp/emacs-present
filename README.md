# Org-present custom configuration #

In order to make this work you need to:
- start emacs with this directory as init-directory
  ```
  emacs --init-directory ~/emacs-present test.org
  ```
- `M-x org-present`
- The first heading (`Hi` in test.org) will not appear when you go right, I know it's a bug and I need to find a way to fix it ;-)

# Other #

- You can explore other themes by using `M-x consult-theme` which will give you a live preview
- You can change the theme by customising `pokemacs-theme` in `custom.el`
