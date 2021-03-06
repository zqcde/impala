#!/usr/bin/env perl
############################################################################
#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# A utility to generate test data for hive test harness tests.
# 
#

use strict;
use charnames ();
use Cwd;

our @firstName = ("alice", "bob", "calvin", "david", "ethan", "fred",
    "gabriella", "holly", "irene", "jessica", "katie", "luke", "mike", "nick",
    "oscar", "priscilla", "quinn", "rachel", "sarah", "tom", "ulysses", "victor",
    "wendy", "xavier", "yuri", "zach");

our @lastName = ("allen", "brown", "carson", "davidson", "ellison", "falkner",
    "garcia", "hernandez", "ichabod", "johnson", "king", "laertes", "miller",
    "nixon", "ovid", "polk", "quirinius", "robinson", "steinbeck", "thompson",
    "underhill", "van buren", "white", "xylophone", "young", "zipper");

sub randomName()
{
    return sprintf("%s %s", $firstName[int(rand(26))],
        $lastName[int(rand(26))]);
}

our @city = ("albuquerque", "bombay", "calcutta", "danville", "eugene",
    "frankfurt", "grenoble", "harrisburg", "indianapolis",
    "jerusalem", "kellogg", "lisbon", "marseilles",
    "nice", "oklohoma city", "paris", "queensville", "roswell",
    "san francisco", "twin falls", "umatilla", "vancouver", "wheaton",
    "xacky", "youngs town", "zippy");

sub randomCity()
{
    return $city[int(rand(26))];
}

our @state = ( "AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", 
    "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
    "MA", "MI", "MN", "MS", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC",
    "ND", "OH", "OK", "OR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA",
    "WA", "WV", "WI", "WY");

sub randomState()
{
    return $state[int(rand(50))];
}

our @classname = ("american history", "biology", "chemistry", "debate",
    "education", "forestry", "geology", "history", "industrial engineering",
    "joggying", "kindergarten", "linguistics", "mathematics", "nap time",
    "opthamology", "philosophy", "quiet hour", "religion", "study skills",
    "topology", "undecided", "values clariffication", "wind surfing", 
    "xylophone band", "yard duty", "zync studies");

sub randomClass()
{
    return $classname[int(rand(26))];
}

our @grade = ("A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-",
    "F");

sub randomGrade()
{
    return $grade[int(rand(int(@grade)))];
}

our @registration = ("democrat", "green", "independent", "libertarian",
    "republican", "socialist");

sub randomRegistration()
{
    return $registration[int(rand(int(@registration)))];
}

sub randomAge()
{
    return (int(rand(60)) + 18);
}

sub randomGpa()
{
    return rand(4.0);
}

our @street = ("A", "B", "C", "D", "E", "F", "G", "H", "I",
    "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
    "T", "U", "V", "W", "X", "Y", "Z");

sub randomStreet()
{
    return sprintf("%d %s st", int(rand(1000)), $street[int(rand(26))]);
}

sub randomZip()
{
    return int(rand(100000));
}

sub randomContribution()
{
    return sprintf("%.2f", rand(1000));
}

our @numLetter = ("1", "09", "09a");

sub randomNumLetter()
{
    return $numLetter[int(rand(int(@numLetter)))];
}

our @greekLetter = ( "alpha", "beta", "gamma", "delta", "epsilon", "zeta",
    "eta", "theta", "iota", "kappa", "lambda", "mu", "nu", "xi", "omicron",
    "pi", "rho", "sigma", "tau", "upsilon", "chi", "phi", "psi", "omega" );

sub randomGreekLetter()
{
    return $greekLetter[int(rand(int(@greekLetter)))];
}

sub randomNameAgeGpaMap()
{
    my $size = int(rand(3));
    my @mapValues = ( "name#" . randomName(), "age#" . randomAge(), "gpa#" . randomGpa() );
    $size = ($size == 0 ? 1 : $size);
    my $map;
    for(my $i = 0; $i <= $size; $i++) {
        $map .= $mapValues[$i];
        if($i != $size) {
            $map .= ",";
        }
    }
    return $map;
}

sub getMapFields($) {
    my $mapString = shift;
    # remove the enclosing square brackets
    $mapString =~ s/[\[\]]//g;
    # get individual map fields
    my @fields = split(/,/, $mapString);
    # get only the values 
    my $hash;
    for my $field (@fields) {
        if($field =~ /(\S+)#(.*)/) {
            $hash->{$1} = $2;
        }
    }
    return $hash;
}

sub randomNameAgeGpaTuple()
{
    my $gpa = sprintf("%0.2f", randomGpa());
    return randomName() . "," . randomAge() . "," . $gpa ;
}

sub randomList()
{
    my $size = int(rand(int(3))) + 1;
    my $bag;
    for(my $i = 0; $i <= $size; $i++) {
        $bag .= randomAge();
        $bag .= "," if ($i != $size);
    }
    return $bag;
}

sub randomEscape()
{
    my $r = rand(1);
    if ($r < 0.16) {
        return '\"';
    } elsif ($r < 0.32) {
        return '\\\\';
    } elsif ($r < 0.48) {
        return '\/';
    } elsif ($r < 0.64) {
        return '\n';
    } elsif ($r < 0.80) {
        return '\t';
    } else {
        return randomUnicodeHex();
    }
}


sub randomJsonString()
{
    my $r = rand(1);
    if ($r < 0.05) {
        return "null";
    } elsif ($r < 0.10) {
        return '"' . randomName() . randomEscape() . randomName() . '"';
    } else {
        return '"' . randomName() . '"';
    }
}

sub randomNullBoolean()
{
    my $r = rand(1);
    if ($r < 0.05) {
        return 'null';
    } elsif ($r < 0.525) {
        return 'true';
    } else {
        return 'false';
    }
}

sub randomJsonMap()
{
    if (rand(1) < 0.05) {
        return 'null';
    }

    my $str = "[";
    my $num = rand(5) + 1;
    for (my $i = 0; $i < $num; $i++) {
        $str .= "," unless $i == 0;
        $str .= '"' . randomCity() . '" : "' . randomName() . '"';
    }
    $str .= "]";
}

sub randomJsonBag()
{
    if (rand(1) < 0.05) {
        return 'null';
    }

    my $str = "[";
    my $num = rand(5) + 1;
    for (my $i = 0; $i < $num; $i++) {
        $str .= "," unless $i == 0;
        $str .= '{"a":' . int(rand(2**32) - rand(2**31)) . ' "b":' .
            randomJsonString() . '}';
    }
    $str .= "]";
}

sub usage()
{
    warn "Usage: $0 filetype numrows tablename hdfstargetdir\n";
    warn "\tValid filetypes [studenttab, studentparttab, \n";
    warn "\t\tstudentnull, allscalars, studentcomplextab, \n";
    warn "\t\tvoternulltab votertab, unicode, json]\n";
    warn "hdfstargetdir is the directory in hdfs that data will be copied to for loading into tables\n";
}

our @greekUnicode = ("\N{U+03b1}", "\N{U+03b2}", "\N{U+03b3}", "\N{U+03b4}",
    "\N{U+03b5}", "\N{U+03b6}", "\N{U+03b7}", "\N{U+03b8}", "\N{U+03b9}",
    "\N{U+03ba}", "\N{U+03bb}", "\N{U+03bc}", "\N{U+03bd}", "\N{U+03be}",
    "\N{U+03bf}", "\N{U+03c0}", "\N{U+03c1}", "\N{U+03c2}", "\N{U+03c3}",
    "\N{U+03c4}", "\N{U+03c5}", "\N{U+03c6}", "\N{U+03c7}", "\N{U+03c8}",
    "\N{U+03c9}");

sub randomUnicodeNonAscii()
{
    my $name = $firstName[int(rand(int(@firstName)))] .
         $greekUnicode[int(rand(int(@greekUnicode)))];
    return $name;
}

sub randomUnicodeHex()
{
    return sprintf "\\u%04x", 0x3b1 + int(rand(25));
}

my $testvar = "\N{U+03b1}\N{U+03b3}\N{U+03b1}\N{U+03c0}\N{U+03b7}";

sub getBulkCopyCmd($$;$)
{
    my ($tableName, $delimeter, $filename) = @_;

    $filename = $tableName if (!defined($filename));
        
    return "load data local infile '" . cwd . "/$filename'
            into table $tableName
            columns terminated by '$delimeter';" 
}


# main
{
    # explicitly call srand so we get the same data every time
    # we generate it.  However, we set it individually for each table type.
    # Otherwise we'd be generating the same data sets regardless of size,
    # and this would really skew our joins.

    my $filetype = shift;
    my $numRows = shift;
    my $tableName = shift;
    my $hdfsTargetDir= shift;

    die usage() if (!defined($filetype) || !defined($numRows) || !defined($tableName) || !defined($hdfsTargetDir));

    if ($numRows <= 0) { usage(); }

    open(HDFS, "> $tableName") or die("Cannot open file $tableName, $!\n");
    open(MYSQL, "> $tableName.mysql.sql") or die("Cannot open file $tableName.mysql.sql, $!\n");
    open(HIVE, "> $tableName.hive.sql") or die("Cannot open file $tableName.hive.sql, $!\n");

    if ($filetype eq "studenttab") {
        srand(3.14159 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (name varchar(100), age integer, gpa float(3));\n";
        print MYSQL &getBulkCopyCmd($tableName, "\t");
        print HIVE "create external table IF NOT EXISTS $tableName(
            name string,
            age int,
            gpa double)
        row format delimited
        fields terminated by '\\t'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
        for (my $i = 0; $i < $numRows; $i++) {
            my $name = randomName();
            my $age = randomAge();
            my $gpa = randomGpa();
            printf HDFS "%s\t%d\t%.2f\n", $name, $age, $gpa;
        }

    } elsif ($filetype eq "studentparttab") {
        srand(3.14159 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (name varchar(100), age integer, gpa float(3), ds char(8));\n";
        print MYSQL &getBulkCopyCmd($tableName, "\t", "$tableName.mysql");
        print HIVE "create external table IF NOT EXISTS $tableName(
            name string,
            age int,
            gpa double)
        partitioned by (ds string)
        row format delimited
        fields terminated by '\\t'
        stored as textfile
        location '$hdfsTargetDir/$tableName';
        alter table $tableName add partition (ds='20110924') location '$hdfsTargetDir/$tableName/$tableName.20110924';
        alter table $tableName add partition (ds='20110925') location '$hdfsTargetDir/$tableName/$tableName.20110925';
        alter table $tableName add partition (ds='20110926') location '$hdfsTargetDir/$tableName/$tableName.20110926';
        ";
        open(MYSQLDATA, "> $tableName.mysql") or die("Cannot open file $tableName.mysql, $!\n");
        for (my $ds = 20110924; $ds < 20110927; $ds++) {
            close(HDFS);
            open(HDFS, "> $tableName.$ds") or die("Cannot open file $tableName.$ds, $!\n");
            for (my $i = 0; $i < $numRows; $i++) {
                my $name = randomName();
                my $age = randomAge();
                my $gpa = randomGpa();
                printf HDFS "%s\t%d\t%.2f\n", $name, $age, $gpa;
                printf MYSQLDATA "%s\t%d\t%.3f\t%d\n", $name, $age, $gpa, $ds;
            }
        }
        close(MYSQLDATA);

    } elsif ($filetype eq "studentnull") {
        srand(3.14159 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (name varchar(100), age integer, gpa float(3));\n";
        print HIVE "create external table IF NOT EXISTS $tableName(
            name string,
            age int,
            gpa double)
        row format delimited
        fields terminated by '\\001'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
        for (my $i = 0; $i < $numRows; $i++) {
            # generate nulls in a random fashion
            my $name = rand(1) < 0.05 ? '' : randomName();
            my $age = rand(1) < 0.05 ? '' : randomAge();
            my $gpa = rand(1) < 0.05 ? '' : randomGpa();
            printf MYSQL "insert into $tableName (name, age, gpa) values(";
            print MYSQL ($name eq ''? "null, " : "'$name', "), ($age eq ''? "null, " : "$age, ");
            if($gpa eq '') {
                print MYSQL "null);\n"
            } else {
                printf MYSQL "%.2f);\n", $gpa;    
            }
            print HDFS "$name$age";
            if($gpa eq '') {
                print HDFS "\n"
            } else {
                printf HDFS "%.2f\n", $gpa;    
            }
            
        }
        print MYSQL "commit;\n";

    } elsif ($filetype eq "allscalars") {
        srand(2.718281828459 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (t tinyint, si smallint, i int, b
            bigint, bool boolean, f float, d double, s varchar(25));\n";
        print MYSQL &getBulkCopyCmd($tableName, ':');
        print HIVE "create external table IF NOT EXISTS $tableName(
            t tinyint,
            si smallint,
            i int,
            b bigint,
            bool boolean,
            f float,
            d double,
            s string)
        row format delimited
        fields terminated by ':'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
        for (my $i = 0; $i < $numRows; $i++) {
            printf HDFS "%d:%d:%d:%ld:%s:%.2f:%.2f:%s\n",
                (int(rand(2**8) - 2**7)),
                (int(rand(2**16) - 2**15)),
                (int(rand(2**32) - 2**31)),
                (int(rand(2**64) - 2**61)),
                rand() >= 0.5 ? "true" : "false",
                rand(100000.0) - 50000.0,
                rand(10000000.0) - 5000000.0,
                randomName();
        }
    } elsif ($filetype eq "studentcomplextab") {
        srand(3.14159 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (nameagegpamap varchar(500), nameagegpatuple varchar(500), nameagegpabag varchar(500), nameagegpamap_name varchar(500), nameagegpamap_age integer, nameagegpamap_gpa float(3));\n";
        print MYSQL "begin transaction;\n";
        print HIVE "create external table IF NOT EXISTS $tableName(
            nameagegpamap map<string, string>,
            struct <name: string, age: int, gpa: float>,
            array <int>)
        row format delimited
        fields terminated by '\\t'
        collection items terminated by ','
        map keys terminated by '#'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
        for (my $i = 0; $i < $numRows; $i++) {
            # generate nulls in a random fashion
            my $map = rand(1) < 0.05 ? '' : randomNameAgeGpaMap();
            my $tuple = rand(1) < 0.05 ? '' : randomNameAgeGpaTuple();
            my $bag = rand(1) < 0.05 ? '' : randomList();
            printf MYSQL "insert into $tableName (nameagegpamap, nameagegpatuple, nameagegpabag, nameagegpamap_name, nameagegpamap_age, nameagegpamap_gpa) values(";
            my $mapHash;
            if($map ne '') {
                $mapHash = getMapFields($map);
            }

            print MYSQL ($map eq ''? "null, " : "'$map', "), 
                        ($tuple eq ''? "null, " : "'$tuple', "),
                        ($bag eq '' ? "null, " : "'$bag', "),
                        ($map eq '' ? "null, " : (exists($mapHash->{'name'}) ? "'".$mapHash->{'name'}."', " : "null, ")),
                        ($map eq '' ? "null, " : (exists($mapHash->{'age'}) ? "'".$mapHash->{'age'}."', " : "null, ")),
                        ($map eq '' ? "null);\n" : (exists($mapHash->{'gpa'}) ? "'".$mapHash->{'gpa'}."');\n" : "null);\n"));
            print HDFS "$map\t$tuple\t$bag\n";
        }
        print MYSQL "commit;\n";

    } elsif ($filetype eq "votertab") {
        srand(299792458 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (name varchar(100), age integer, registration varchar(20), contributions float);\n";
        print MYSQL &getBulkCopyCmd($tableName, "\t");
        print HIVE "create external table IF NOT EXISTS $tableName(
            name string,
            age int,
            registration string,
            contributions float)
        row format delimited
        fields terminated by '\\t'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
for (my $i = 0; $i < $numRows; $i++) {
            my $name = randomName();
            my $age = randomAge();
            my $registration = randomRegistration();
            my $contribution = randomContribution();
            printf HDFS "%s\t%d\t%s\t%.2f\n", $name, $age,
                $registration, $contribution;
        }

    } elsif ($filetype eq "voternulltab") {
        srand(299792458 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (name varchar(100), age integer, registration varchar(20), contributions float);\n";
        print MYSQL "begin transaction;\n";
        print HIVE "create external table IF NOT EXISTS $tableName(
            name string,
            age int,
            registration string,
            contributions float)
        row format delimited
        fields terminated by '\\t'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
        for (my $i = 0; $i < $numRows; $i++) {
            # generate nulls in a random fashion
            my $name = rand(1) < 0.05 ? '' : randomName();
            my $age = rand(1) < 0.05 ? '' : randomAge();
            my $registration = rand(1) < 0.05 ? '' : randomRegistration();
            my $contribution = rand(1) < 0.05 ? '' : randomContribution();
            printf MYSQL "insert into $tableName (name, age, registration, contributions) values(";
            print MYSQL ($name eq ''? "null, " : "'$name', "), 
                            ($age eq ''? "null, " : "$age, "),
                            ($registration eq ''? "null, " : "'$registration', ");
            if($contribution eq '') {
                print MYSQL "null);\n"
            } else {
                printf MYSQL "%.2f);\n", $contribution;    
            }
            print HDFS "$name\t$age\t$registration\t";
            if($contribution eq '') {
                print HDFS "\n"
            } else {
                printf HDFS "%.2f\n", $contribution;    
            }
        }
        print MYSQL "commit;\n";

    } elsif ($filetype eq "unicode") {
        srand(1.41421 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (name varchar(255));\n";
        print MYSQL "begin transaction;\n";
        print HIVE "create external table IF NOT EXISTS $tableName(
            name string)
        row format delimited
        fields terminated by '\\t'
        stored as textfile
        location '$hdfsTargetDir/$tableName';\n";
        for (my $i = 0; $i < $numRows; $i++) {
            my $name = randomUnicodeNonAscii(); 
            printf MYSQL "insert into $tableName (name) values('%s');\n", $name;
            printf HDFS "%s\n", $name;
        }
        print MYSQL "commit;\n";
    } elsif ($filetype eq "json") {
        srand(6.0221415 + $numRows);
        print MYSQL "create table IF NOT EXISTS $tableName (s varchar(200),
              i int, d double, b boolean, m varchar(2048), 
              bb varchar(2048));\n";
        print MYSQL "begin transaction;\n";
        print HIVE "create external table IF NOT EXISTS $tableName(
            s string,
            i int,
            d double,
            b boolean,
            m map<string, string>,
            bb array<struct<a: int, b: string>>)
        stored as textfile
        location '$hdfsTargetDir/$tableName'
        TBLPROPERTIES (
            'hcat.isd'='org.apache.hcatalog.json.JsonInputDriver',
            'hcat.osd'='org.apache.hcatalog.json.JsonOutputDriver'
        );\n";
        for (my $i = 0; $i < $numRows; $i++) {
            my $s = randomJsonString();
            my $i = rand(1) < 0.05 ? 'null' : (int(rand(2**32) - 2**31)),
            my $d = rand(1) < 0.05 ? 'null' : (rand(2**10) - 2**9),
            my $b = randomNullBoolean();
            my $m = randomJsonMap();
            my $bb = randomJsonBag();

#           printf MYSQL "insert into $tableName (name) values('%s');\n", $name;
            print HDFS qq@{"s":$s, "i":$i, "d":$d, "b":$b, "m":$m, "bb":$bb}\n@
        }
        print MYSQL "commit;\n";

    } else {
        warn "Unknown filetype $filetype\n";
        usage();
    }
}


