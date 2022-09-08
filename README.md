# get urls from robots.txt

# usage

## options
```
-o/--output /path/to/output.txt, default ./output.txt
-t/--timeout request timeout in seconds, default 3 seconds
-u/--url url to get
-h/--help show help
```

**url can be https:// or without https://**

## help
./robots.sh -h

## multi urls from file
> cat urls-file.txt | ./robots.sh

## one url
> ./robots.sh -u https://domain.com
