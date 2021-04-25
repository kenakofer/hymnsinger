#!/bin/bash
find . -print0 | while IFS= read -r -d $'\0' f; do
  new="${f//_/-}"
  if [ "$new" != "$f" ]
  then
    if [ -e "$new" ]
    then
      echo not renaming \""$f"\" because \""$new"\" already exists
    else
      echo moving "$f" to "$new"
    mv "$f" "$new"
    fi
  fi
done
