
%inc "template.tpl";

ods tagsets.template file="test.txt" options(yes_no_option="yes");
ods _all_ close;

ods tagsets.template file="test.txt" options(yes_no_option="off");
ods _all_ close;
