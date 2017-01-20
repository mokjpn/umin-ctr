# umin-ctr: a npm package to retrieve UMIN-CTR(Clinical Trial Registry) information by trial id.

## Description

UMIN-CTR is a part of Japanese primary clinical trial registry. This is an unofficial UMIN-CTR client that can be used to obtain trial information by its ID.
For more information of Clinical Trial Registry, please refer to WHO International Clinical Trials Registry Platform (ICTRP): http://www.who.int/ictrp/en/
UMIN-CTR is located at http://www.umin.ac.jp/ctr/index.htm

## Installation

```
$ npm install -g mokjpn/umin-ctr
```

## Usage

```
$ node
> ctr = require('umin-ctr')
> ctr('UMIN000001159', rid, function(trial) { console.log JSON.stringify trial });
```
