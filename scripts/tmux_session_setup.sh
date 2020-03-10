#!/bin/env bash

# Quit if some error occurs
set -e

# If the session is already loaded, quit the script
case "$(tmux list-sessions -F '#{session_name}')" in
    *"wildfly-testbench"*)
        echo -e "A session called 'wildfly-testbench' is \nalready running: the script won't proceed!"
        exit 1 ;;
esac

# Start the Vagrant VMs
vagrant up
# Create session and split window into 3 panes
tmux new-session -ds 'wildfly-testbench'
tmux split-window -h -t wildfly-testbench
tmux split-window -v -t wildfly-testbench
# SSH into the Vagrant VMs
tmux send-keys -t wildfly-testbench:1.0 'vagrant ssh master' Enter
tmux send-keys -t wildfly-testbench:1.1 'vagrant ssh slave-bravo' Enter
tmux send-keys -t wildfly-testbench:1.2 'vagrant ssh slave-charlie' Enter
# Clear the terminal's screens
for _pane in $(tmux list-panes -F '#P' -t wildfly-testbench); do
    tmux send-keys -t wildfly-testbench:1.${_pane} C-l
done
# Start a TMux session in all the panes
echo -e "Tmux will be started in all SSH sessions:\nto control the host tmux Ctrl+A is needed,\nwhile on the guests Ctrl+B will still be used\n(the shortcut is remapped from this script)\n"
read -r -p "Hit ENTER to continue"
tmux unbind-key -T prefix C-b
tmux bind-key -T prefix C-a send-prefix
for _pane in $(tmux list-panes -F '#P' -t wildfly-testbench); do
    tmux send-keys -t wildfly-testbench:1.${_pane} 'tmux' Enter
    sleep 1
done
# Show the IP address in the statusbar
for _pane in $(tmux list-panes -F '#P' -t wildfly-testbench); do
    tmux send-keys -t wildfly-testbench:1.${_pane} 'tmux set -g status-right " \"#{=21:pane_title}\" [$(ip addr show eth0 | grep -w "inet" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -n1)] %H:%M %d-%b-%y"' Enter
    sleep 1
done
# Clear the terminal's screens
for _pane in $(tmux list-panes -F '#P' -t wildfly-testbench); do
    tmux send-keys -t wildfly-testbench:1.${_pane} C-l
done

# Attach to the created session
tmux attach-session -t wildfly-testbench
