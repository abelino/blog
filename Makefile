create-orphans:
	@if ! git checkout --quiet gh-pages; then                                   \
    git checkout --quite --orphan gh-pages;                                   \
    git checkout --quiet master;                                              \
  fi
	@echo inside
	@if ! git checkout --quiet content; then                                    \
    echo -e "\033[0;32mCreating orphan branch 'content'...\033[0m";           \
    git checkout --quite --orphan gh-pages;                                   \
    git checkout --quiet master;                                              \
  fi

setup:
	@if [ ! -d themes ]; then                                                   \
    mkdir themes &&                                                           \
    git clone git@github.com:AlexFinn/simple-a.git themes/simple-a;           \
  fi

