# GitIntegrate

Given a list of branches, create an integration branch that merges them
all.

## Installation

Put the `git_integrate` executable in your `PATH`.

## Usage

The following things are assumed:
* You're going to branch off of a branch called `develop`.
* You have a `.integration_branches.json` file that lists the branches
  you want merged into your integration branch.
