#!/bin/bash

# REPOSITORY RENAMING FUNTIME 2019 IS UPON US!

OLD_MODULE_NAMES=(kipro vicreo-hotkey.git thinkm-blink1)
KEEP_MODULES=()
REMOVE_MODULES=()

FOUND=0


for module in "${OLD_MODULE_NAMES[@]}";
do
	if [ -d "lib/module/${module}" ]; then
		FOUND=$[$FOUND+1]
	fi
done

if [ "$FOUND" -eq 0 ]; then
	exit 0
fi
			
echo -e "\033[1mREPOSITORY RENAMING FUNTIME 2019 IS UPON US!\033[m
This process affects our module developers in a couple of ways 

* When we deinit the old name and init the new name in git, it leaves the old module folder as untracked. But since it's there, it will cause a conflict in companion when you try to start it. You basically have the same module two places.

We found $FOUND conflicting modules.
"

for module in "${OLD_MODULE_NAMES[@]}";
do
	if [ -d "lib/module/${module}" ]; then
		prompt="-"
		while [[ ! "$prompt" =~ ^[YyNn]?$ ]]; do
			echo -en "Do you have any local uncommited changes to the \033[1mlib/modules/${module}\033[m folder that you want to keep? [N]: "
			read -n 1 -r prompt
			echo
		done

		if [[ "$prompt" =~ ^[Yy]$ ]]; then
			KEEP_MODULES+=($module)
		fi
		if [[ "$prompt" =~ ^[Nn]$ ]] || [ "$prompt" == "" ]; then
			REMOVE_MODULES+=($module)
		fi
	fi
done

if [ "${#KEEP_MODULES[@]}" -gt 0 ]; then
	echo
	echo -e "So, you've decided to \033[1mkeep\033[m the following folders:"
	for module in "${KEEP_MODULES[@]}";
	do
		echo -e "\tlib/module/$module"
	done
	echo
	echo "Remember that companion will NOT work properly until you've removed those folders manually"
	echo
	echo "To continue, hit ENTER."
	read
fi

if [ "${#REMOVE_MODULES[@]}" -gt 0 ]; then
	echo
	echo -e "We are now going to \033[1mremove\033[m the following folders in your source folder:"

	for module in "${REMOVE_MODULES[@]}";
	do
		echo -e "\tlib/module/$module"
	done

	echo
	echo "If you have any regrets of this decision, please hit CTRL+C now, and rerun this script with the correct choices."
	echo
	echo "To continue, hit ENTER."
	read

	for module in "${REMOVE_MODULES[@]}";
	do
		if [ "$module" != "" ]; then
			rm -rf "lib/module/$module"
		fi
	done
fi
