# Why I wrote this

This is useful in situations where PRs aren't merged into the main
branch of development as fast as feature branches are created. For
example, I create a branch "featureA", finish the feature, then open a
PR. While that PR is in review, I branch off "featureA" to start
work on "featureB". I finish that one, then branch off "featureB" to
start work on "featureC" and so on. Eventually, the reviewers will look at
the "featureA" PR and make suggestions for improvement. After I make the
changes and the PR gets approved and merged, all of the branches that
are descendants of "featureA" are out of date. `git_cascade
featureA` will automatically rebase the descendant branches onto their
parents.

# How does this work?

You must specify the branch dependencies in a `.dependent_branches.json`
file. See the comments in `.dependent_branches.json.example`. Put the
script in your `PATH` and make sure it's executable. Then you can call
`git_cascade [branch_name]`, where `branch_name` is the branch that you
want the updates to cascade from.
