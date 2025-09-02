#!/usr/bin/env bash
set -euo pipefail

ARELLE_PY="/opt/Arelle/arelleCmdLine.py"

show_help() {
  cat <<'EOF'
Multi-tool SEC-RAG container. Usage:

  arelle [Arelle CLI args...]           Run Arelle CLI
  sec-parse [args...]                    Run SEC-RAG pipeline CLI (python -m sec_rag.cli)
  python [args...]                       Run Python in the sec_rag env
  ipython [args...]                      Run IPython in the sec_rag env
  jupyter [args...]                      Run Jupyter (e.g., jupyter lab --ip=0.0.0.0 --no-browser)
  bash                                   Open a shell
  help                                   Show this help

Examples:
  docker run --rm -v $PWD:/work IMAGE arelle --help
  docker run --rm -v $PWD:/work IMAGE arelle --file /work/10k.htm --plugins --validate
  docker run --rm -v $PWD:/work IMAGE sec-parse --input /work/edgar_dump --out /work/out
  docker run -it --rm -p 8888:8888 -v $PWD:/work IMAGE jupyter lab --ip=0.0.0.0 --no-browser --NotebookApp.token=''
EOF
}

cmd="${1:-help}"
shift || true

case "$cmd" in
  help|-h|--help)
    show_help
    ;;

  arelle)
    exec python "$ARELLE_PY" "$@"
    ;;

  sec-parse)
    exec python -m sec_rag.cli "$@"
    ;;

  python)
    exec python "$@"
    ;;

  ipython)
    exec ipython "$@"
    ;;

  jupyter)
    exec jupyter "$@"
    ;;

  bash|sh)
    exec bash "$@"
    ;;

  *)
    echo "Unknown command: $cmd" >&2
    echo
    show_help
    exit 2
    ;;
esac
