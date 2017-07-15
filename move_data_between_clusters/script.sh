function _LOG()
{
    echo "[$(date '+%Y-%m-%d %H:%M:%S')][SC][${FUNCNAME[1]}]: ${1}"
}

function _ASSERT_ENUM()
{
    local __CNT && __CNT=$(echo ",${2}," | sed -e '/,'"${1}"',/!d' | wc -l)
    if [[ "${__CNT}" == "1" ]]; then
        return 0
    fi
    
    _LOG "ERROR: assert failed. String [${1}] is not in enum [${2}]"
    _LOG "  MSG: ${3:-No message}"
    _LOG "CHAIN:"
    
    local __LEN && __LEN="${#FUNCNAME[*]}"
    local __CNT=0
    while (( __CNT < __LEN )); do
        _LOG "-> ${FUNCNAME[__CNT]}"
        let "__CNT=__CNT+1"
    done
    
    return 1
}
function _ASSERT_STR()
{
    local __TRIMMED="${1}"
    __TRIMMED="${__TRIMMED#"${__TRIMMED%%[![:space:]]*}"}"
    __TRIMMED="${__TRIMMED%"${__TRIMMED##*[![:space:]]}"}"
    
    if [[ -n "${__TRIMMED}" ]]; then
        return 0
    fi
    
    _LOG "ERROR: assert failed. String [${1}] is empty"
    _LOG "  MSG: ${2:-No message}"
    _LOG "CHAIN:"
    
    local __LEN && __LEN="${#FUNCNAME[*]}"
    local __CNT=0
    while (( __CNT < __LEN )); do
        _LOG "-> ${FUNCNAME[__CNT]}"
        let "__CNT=__CNT+1"
    done
    
    return 1
}

_LOG "start"


while getopts src:trg:qry: option
do
 case "${option}"
 in
 src) __SOURCE=${OPTARG};;
 trg) __TARGET=${OPTARG};;
 qry) __QUERY=${OPTARG};;
 esac
done

_LOG "from ${__SOURCE} to $__TARGET using $__QUERY"
