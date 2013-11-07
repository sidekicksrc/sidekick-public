
main() {
  set -e
  check_deployable()
  deploy()
}
check_deployable() {
  diffs=git diff --name-status HEAD | wc -l
  if [[ $diffs != "0" ]]; then
    echo "Can't deploy, unsaved changes:"
    git diff --name-status HEAD
  fi
}

deploy() {
  rm -rf output
  checkout_clean_branch()
  compile()
  git add -f output
  git commit -m 'compiled'
  git checkout deploy
  add_output()
}

add_output() {
  tree=git ls-tree -d | grep -w output | awk '{print $3}'
  echo "Output folder tree" $tree
}

checkout_clean_branch() {
  # deploy-staging is an orphan branch, only history on it is deployed versions
  git checkout deploy-staging
}

compile() {
  NANOC_ENV=production nanoc compile
}
