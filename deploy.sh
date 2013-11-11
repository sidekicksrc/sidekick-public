main() {
  set -e
  check_deployable
  deploy
}
check_deployable() {
  diffs=`git diff --name-status HEAD | wc -l`
  if [[ $diffs != "0" ]]; then
    echo "Can't deploy, unsaved changes:"
    git diff --name-status HEAD
    exit 1
  fi
}

deploy() {
  rm -rf output
  checkout_clean_branch
  compile
  git add -f output
  git commit -m 'compiled'
  git checkout deploy
  create_commit
  git push origin deploy
}

most_recent_deploy() {
  git show-ref deploy-staging | awk '{print $2}'
}

create_commit() {
  commit=most_recent_deploy
  tree=git ls-tree -d | grep -w output | awk '{print $3}'
  parent_opt=""
  if [[ $commit != "" ]]; then
    parent_opt="-p $commit"
  fi
  new_commit=git commit-tree $tree -m 'new version' $parent_opt
  git update-ref deploy $new_commit
}

checkout_clean_branch() {
  # deploy-staging is an orphan branch, only history on it is deployed versions
  git checkout deploy-staging
}

compile() {
  NANOC_ENV=production nanoc compile
}


main
