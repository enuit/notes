# functions
# --------------------------------------------------
function checknote {
  if [ ! -f "$1${_ext}" ]; then
    echo "the note ${_bold}$1${_normal} does not exist"
    exit 1
  fi
}

function checkdir {
  if [ ! -d "$1" ]; then
    echo "the directory ${_bold}$1${_normal} does not exist"
    exit 1
  fi
}

function checknoteordir {
  if [ ! -f "$1${_ext}" ] && [ ! -d "$1" ]; then
    echo "neither the note nor directory ${_bold}$1${_normal} exists"
    exit 1
  fi
}

# hash is faster than which
function checkexec {
  if hash $1 2>/dev/null; then
    :
  else
    echo "the executable ${_bold}$1${_normal} does not exist"
    exit 1
  fi
}

function checkname {
  if echo $1 | grep -E "[[:space:]]" >/dev/null; then
    echo "neither note nor directory names may contain whitespace characters"
    exit 1
  fi
}

function previewnotes {

  TRAILINGSPACES=50
  INDENT="     "
  MAXCHARS=25
  DESCRIPTIONCHARS=50

  # ignore parent directory, ignore hidden files and directories, ignore files without proper extension
  find ${1} ! -path ${1} ! -path "*/\.*" \( -type f -name "*${_ext}" -or -type d \) 2>/dev/null \
  | while read x; do
    # remove leading ./ with cut, replace remaining path segments with indent spaces, then remove all non-space chars
    indent=`echo $x | cut -c 3- | sed -E "s:[^/]+/:$INDENT:g" | sed -E "s/[^ ]//g"`

    # get basename of note without extension, and trim excessively long names
    name=`basename "$x" | cut -d. -f1`
    name=${name:0:$MAXCHARS}

    numspaces=$[$TRAILINGSPACES - ${#name}]
    spaces=`head -c $numspaces < /dev/zero | tr '\0' ' '`

    if [ -f $x ]; then
      desc="`head -c $DESCRIPTIONCHARS $x | tr '\n' ' ' 2>/dev/null`..."
      echo -e "${indent}${_bold}${name}${_normal}${spaces}${desc}"

    elif [ -d $x ]; then
      desc="/"
      echo -e "${indent}${name}${spaces}${desc}"

    fi
  done

}



# help
# --------------------------------------------------
unset usage
usage() {
  cat << EOF

${_bold}NAME${_normal}
    ${_bold}${name}${_normal}

${_bold}SYNOPSIS${_normal}
    ${_bold}${name}${_normal} [${_bold}-hclLmnNOpPrR${_normal}] note ...

${_bold}DESCRIPTION${_normal}
    [ ${_bold}-h${_normal} ]                                  get help (display this page)
    [ ${_bold}-c${_normal} TGT_NOTE NOTE_A NOTE_B ... ]       combine notes: append text in notes a,b,... to target note. can be used to copy a note**
    [ ${_bold}-f${_normal} PATTERN ]                          find notes: search for notes matching pattern (all matches)
    [ ${_bold}-F${_normal} PATTERN ]                          find notes: search for notes matching pattern (note names only)
    [ ${_bold}-l${_normal} NOTE ]                             show paths of all notes under home directory with same inode as this note (notes connected by hard links)
    [ ${_bold}-L${_normal} SOURCE_NOTE TARGET_NOTE ]          create a hard link between source note and target note. source note must exist in notes directory
    [ ${_bold}-m${_normal} NOTE NEW_NOTE ]                    move a note (change its name). can not be used to overwrite an existing note
    [ ${_bold}-n${_normal} NEW_NOTE ]                         create and open a note
    [ ${_bold}-N${_normal} NEW_DIR ]                          create a directory
    [ ${_bold}-O${_normal} ]                                  open notes directory
    [ ${_bold}-p${_normal} NOTE ]                             print contents of note
    [ ${_bold}-P${_normal} [NOTE_OR_DIR] ]                    print full path to note or directory
    [ ${_bold}-r${_normal} NOTE ]                             remove (delete) a note
    [ ${_bold}-R${_normal} DIR ]                              remove (delete) a directory

    **
      ${name} -c copy original


    All of these options are mutually exclusive, i.e. at most one option should be passed to ${_bold}${name}${_normal}.


    If ${_bold}${name}${_normal} is invoked without any options, the following modes of execution exist:

      - zero arguments        :                             list all notes
      - one argument          <note_or_dir>:                open this note, or list all notes under this directory
      - two arguments         <program> <note_or_dir>:      pass note or directory as argument to program
      - two arguments         <program> <glob_pattern>:     pass all matched notes as arguments to program, simply replace ${_bold}*${_normal} with ${_bold}${_glob}${_normal}
      - g.t. two arguments    <program> <notes>:            pass notes as arguments to program

${_bold}EXAMPLES${_normal}
      - notes 'grep password' ${_glob}
      - notes open github

${_bold}EXTENSIONS${_normal}
      All notes have a default extension of ${_bold}${_ext}${_normal}, which is assigned to the variable ${_bold}_ext${_normal} in the source code of this program. Edit this variable to change or remove the extension. The extension should never be passed to ${_bold}notes${_normal} in any of its modes of execution.
EOF
}