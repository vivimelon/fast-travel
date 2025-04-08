🧭 fast-travel

Because sysadmin life already feels like a video game — might as well add teleportation.

✨ What is this?

fast-travel is a tiny shell utility I mashed together for funsies to make my sysadmin/devops life a bit easier.

Pairs well with tmux like honey and butter.

Tired of copy-pasting IPs, PEM files, and typing long SSH commands like some kind of medieval peasant? Same. So I made this.

Now I can just:

fast-travel bastion-host

🛠️ What does it do?

    Lets you define checkpoints (AKA servers) with a name, IP/domain, and PEM key.

    Stores them in ~/.ssh/hosts/hosts.txt

    Gives you autocomplete for fast-travel <checkpoint>

    Has add-checkpoint and remove-checkpoint to manage your list

    Reuses blank lines when removing/adding checkpoints, to keep the list tidy

    Uses your PEM keys from ~/.ssh/keys/

    Adds a little ✨ flair ✨ to your terminal life

🚀 Setup

    Drop the functions from fast-travel.zsh (or copy from below) into your ~/.zshrc

    Create a file to hold your checkpoint list:

mkdir -p ~/.ssh/hosts
touch ~/.ssh/hosts/hosts.txt

Store all your .pem keys in:

~/.ssh/keys/

Then reload your shell:

    source ~/.zshrc

⚙️ Usage
Add a new checkpoint:

add-checkpoint my-server 12.34.56.78 my-key.pem

    This creates an entry like: my-server 12.34.56.78 my-key.pem

Teleport to a server:

fast-travel my-server

    Outputs: ✨ Fast-travelling to my-server... 🧭 and SSHs you in.

Remove a checkpoint:

remove-checkpoint my-server

    Clears the line in the list so it can be reused later.

Autocomplete:

Just press TAB after typing:

fast-travel <TAB>

It’ll suggest available checkpoints.

🙃 License?

MIT. Copy it, change it, break it, have fun.

Note: Its not the best idea in the world to keep a list of unhashed sever domains and their corresponding pem 
files so I only really recommend using this for non-critical servers for whom the convenience really outweighs
the risk

