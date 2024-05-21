# Releases of Viper
# Viper Release names and Version numbers

- 1.x : Unnamed
- 2.x : Cleo
2.1.x: Indy
- 3.x :  Karl

## Explanations of Release Names

### Cleo : 2.x series

Cleopatra, the Queen of the Nile was said to have taken her own life by letting herself
get bitten by an Asp, otherwise known as an Egyptian Cobra.

## 2.1 Indy

The many Indiana Jones  franchise movies, had many a snake to perplex our hero
with tricky puzzle solves without getting bit.

## Karl : 3.x series

Karl Patterson Schmidt , was a American Herpatologist who documented his own death after being bitten byboomslang
snake in 1957. He wrongly believed it would not be fatal.


## Instructions on creating a new release

Note: These instructions are output when you do: 'rake -q release' including checking for to-dos, and left over bindings

1. Update lib/vish/version.rb and bump the version number

2. Cleanup code, remove '#binding.pry' and any non-comment '=begin/=end' comment out blocks of code
  * Run 'rake todo' to check for left over comments in  code for unfinished things to do, remove or needs fixing
3. Update README.md, bump version# and release name
4. Add release notes to CHANGELOG.md
5. Make sure rake runs cleanly
6. add/commit all changes.
  * remove any untracked files
7. Do the commit
8. Git tag -a X.x.p (E.g. git tag -a 2.0.11 -m 'Release 2.0.11)
9. git push
  * git push --follow-tags origin master

