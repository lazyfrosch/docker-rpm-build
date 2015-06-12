Docker RPM build
================

Containers and scripts I use to build RPM packages for RHEL/CentOS.

## Usage

Build the containers:

```
cd centos6/; make
cd centos7/; make
```

Build an RPM

```
./build.sh lazyfrosch/centos7-rpm-build SPECS/perl-YAML-Syck.spec
```

Test something inside a container:

```
./test.sh lazyfrosch/centos7-rpm-build /bin/bash
```

## License

    Copyright (C) 2015 Markus Frosch <markus@lazyfrosch.de>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You find a full copy of the license in the file LICENSE.
