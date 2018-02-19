#!/bin/bash -x


dblog='docker run -it --rm --name some-docker-blog -v '$PWD'/blog-0.10/example:/example openkbs/docker-blog-bayesian blog'

$dblog /example/burglary.blog
