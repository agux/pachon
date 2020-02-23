# Pachon

China A-share market data mining, engineering & analysis tool written in go.

Migrated from [carusyte/stock](https://github.com/carusyte/stock)

## Highlight Features

## Overall Design

- a web data retriever to fetch data from public sources
- a mapper to store in database (MySQL)
- methods and functions apply on offline data for regression

## Dependencies

[golang](https://golang.org/) version >= 1.13.6

github.com

- [agux/roprox](https://github.com/agux/roprox) for rotating proxy
- [sirupsen/logrus](https://github.com/sirupsen/logrus) for logging
- [spf13/cobra](https://github.com/spf13/cobra") for cli interfaces

golang.org

- [x/text/encoding/simplifiedchinese](https://golang.org/x/text/encoding/simplifiedchinese)
- [x/text/encoding/transform](https://golang.org/x/text/encoding/transform)
- [x/net/proxy](https://golang.org/x/net/proxy)

## Usage

### Build

    # have go-lang installed, (v1.13.6)
    # have latest git installed (v2.24)

    # this might take few minutes
    cd %GOPATH%\src\github.com\agux\pachon
    go get ...

    # known issue https://github.com/grpc/grpc-go/issues/3312
    cd %GOPATH%\src\google.golang.org\grpc
    git revert 336cf8d       

    cd %GOPATH%\src\github.com\agux\pachon
    go install

### Run

1. Before running the program, copy the `stock.sample.toml` config file template to `$GOPATH/bin`,
and rename to `stock.toml`.

2. Customize/Localize the 'stock.toml' file accordingly.

3. If you have your executable search path environment variable properly set, you should
be able to run the following command directly. This command will list out all sub-commands
and its usage.

    ```
    pachon help
    ```

4. You might need [agux/roprox](https://github.com/agux/roprox) to run in parallel in order to fetch publicly available proxy servers.

5. To start fetching A-share market data:

    ```
    pachon get
    ```

*there are still some config parse problem, instruction required*

## FAQ

### can't find package xx at 'go get'

re-fetch via 'go get -u', or direclty remove correspoding package folder and run it again

    go get -u golang.org/x/text
