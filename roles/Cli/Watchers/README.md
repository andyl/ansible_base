# Watchers

Install command-line file system watchers:

|----------------|------------|----------------------|
| Watcher        | Pros       | Cons                 |
|----------------|------------|----------------------|
| [fswatch][1]   | simple     | no dedup             |
| [entr][2]      | integrated | complicated install  |
| [watchexec][3] | integrated | intertwined concerns |
|----------------|------------|----------------------|

More info: a [survey][4] of file-system watchers.

[1]: https://emcrisostomo.github.io/fswatch
[2]: http://eradman.com/entrproject
[3]: https://watchexec.github.io
[4]: https://anarc.at/blog/2019-11-20-file-monitoring-tools

## Fswatch Install

- precompile and cache in var/data/cblob 
- install cached assets using Fswatch 

## Entr Install 

- download compiled 

## Watchexec Install

- download deb file
- install using debian tools 


