#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);
use Data::Dumper;

use JSON; # to install, # sudo cpan JSON
$json_engine	= JSON->new->allow_nonref;
$server = "my.velantro.com";
$DEBUG  = 1;
$data = md5_hex('admin@velantro.com:admin5');
$realm = "sip.velantro.com";
#$data = md5_hex('zhongxiang721@gmail.com:admin5');
#$realm = "32nmhrh.my.velantro.com";
#$data = md5_hex('admin@samsung.com:admin5');
#$realm = "7vph9kk.my.velantro.com";
#print $data;

%hash = &query('PUT', 'v1/user_auth', qq`{ "data" : { "credentials" : "$data", "realm" : "$realm" } }`);

#$res = `curl -X PUT http://my.velantro.com:8000/v1/user_auth -H "Content-Type:application/json" -d '{ "data" : { "credentials" : "$data", "realm" : "$realm" } }'`;

#%hash = &Json2Hash($res);
#print Dumper(\%hash);

print "auth token:\n";
print $hash{auth_token};
print "\n";

$account_id = $hash{data}{account_id};
$auth_token = $hash{auth_token};
$request_id = $hash{request_id};

warn "query storage:\n";
#$res = `curl   -X DELETE -H "X-Auth-Token: $auth_token" \ "http://$server:8000/v2/accounts/$account_id/storage"`;
#$cmd = curl   -H "X-Auth-Token: $auth_token" \ "http://$server:8000/v2/accounts/$account_id/storage";
$res = `$cmd`;
%n = &query('GET', "v2/notifications/new_account");
#%n = &query('GET', "v2/notifications");
#for (@{$n{data}}) {
	#print $_->{id}, "\n";
#}
#print Dumper(&Json2Hash($res));

exit 0;

#warn "create initial storage:\n";

&query('PUT', "v2/accounts/$account_id/storage", '{"data":{}}');

#print "curl   -X POST --data-binary \@\"/salzh/kazoo4/api/logo3.png\" -H \"X-Auth-Token: $auth_token\"  http://$server:8000/v2/accounts/$account_id/whitelabel/logo";

#$res = `curl   -X GET  -H "X-Auth-Token: $auth_token"  http://$server:8000/v2/accounts/$account_id/whitelabel/whitelabel`;
#%hash = &Json2Hash($res);

#print Dumper($hash{data});


#$res = `curl   -X PUT  -H "X-Auth-Token: $auth_token"  -d '{"data":{}}' "http://$server:8000/v2/accounts/$account_id/storage"`;
#print $res;


print "\n\nCreate S3 STORAGE:\n";
$uuid = &uuid();

$json =<<S;
{"data":{
    "attachments": {
        "$uuid":{
            "handler":"s3",
            "name":"Kazoo S3",
            "settings":{
                "bucket":"kazoorecordings",
                "key":"AKIAIQ2QMZUEQFENYOSA",
                "secret":"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"
            }
        }
    }
}}
S

&query('PATCH', "v2/accounts/$account_id/storage", $json);

#$res = `curl   -X PATCH -H "content-type: application/json" -H "X-Auth-Token: $auth_token" "http://$server:8000/v2/accounts/$account_id/storage" -d '$json'`;
#print $res, "\n";


#$type = 'fax'; #'call_recording,mailbox_message';
#$uuid = &uuid();


$json =<<P;
{"data":{"plan":{
        "modb":{
            "types":{
                "call_recording":{
                    "attachments":{
                        "handler":"$uuid"
                    }
                }
            }
        }
    }}}
P

&query('PATCH', "v2/accounts/$account_id/storage", $json);

$json =<<M;
{"data":{"plan":{
        "modb":{
            "types":{
                "mailbox_message":{
                    "attachments":{
                        "handler":"$uuid"
                    }
                }
            }
        }
    }}}
M

&query('PATCH', "v2/accounts/$account_id/storage", $json);

#$res = `curl   -X PATCH -H "content-type: application/json" -H "X-Auth-Token: $auth_token" "http://$server:8000/v2/accounts/$account_id/storage" -d '$json'`;
#print $res;

#print $json;
#$res = `curl   -X PATCH   -H "X-Auth-Token: $auth_token"   -d '$json'  "http://$server:8000/v2/accounts/$account_id/storage"`;

#print $res;
=pod
$uuid = &genuuid;

$res = `curl -X PUT http://my.velantro.com:8000/v1/api_auth -H "Content-Type:application/json" -d '{ "data" : { "api_key" : "$uuid" }}'`;

print $res;

sub genuuid () {
  @char = (0..9,'a'..'f');
  $size = int @char;
  local $uuid = '';
  for (1..64) {
      $s = int rand $size;
      $uuid .= $char[$s];
  }
  

  return $uuid;
} 

=cut
sub Array2Json() {
	local(@jason_data) = @_;
	# hack: error.code need be a numeric if value is 0
	#if ( exists($jason_data{error}) ){
	#	if ($jason_data{error}{code} == "0"){
	#		$jason_data{error}{code} = 0;
	#	}
	#}
	my $json_data_reference = \@jason_data;
	my $json_data_text		= $json_engine->encode($json_data_reference);
	return $json_data_text;
}


# ==============================================
# json/response libs
# ==============================================
sub Json2Hash(){
	local($json_plain) = @_;
	local(%json_data);
	my %json_data = ();
	if ($json_plain ne "") {
		local $@;
		eval {
			$json_data_reference	= $json_engine->decode($json_plain);
		};
		
		if ($@) {warn $@}
		%json_data			= %{$json_data_reference};
	}
	return %json_data;
}
sub Hash2Json(){
	local(%jason_data) = @_;
	# hack: error.code need be a numeric if value is 0
	#if ( exists($jason_data{error}) ){
	#	if ($jason_data{error}{code} == "0"){
	#		$jason_data{error}{code} = 0;
	#	}
	#}
	my $json_data_reference = \%jason_data;
	my $json_data_text		= $json_engine->encode($json_data_reference);
	return $json_data_text;
}

sub query {
	local ($method, $path, $data) = @_;
	warn "$method, $path, $data";
	if ($data) {
		$cmd = qq`curl  -X $method http://$server:8000/$path -H "Content-Type:application/json" -H "X-Auth-Token: $auth_token" -d '$data'`;
	} else {
		$cmd = qq`curl  http://$server:8000/$path -H "Content-Type:application/json" -H "X-Auth-Token: $auth_token"`;
	}
	print "request: $cmd\n" if $DEBUG;

	local $res = `$cmd`;
	
	local %hash = &Json2Hash($res);
	print Dumper(\%hash) if $DEBUG;
	
	return %hash;
}

sub uuid {
	
	local $uuid  =  `uuid`;
	
	$uuid =~ s/\-//g;
	
	chomp $uuid;
	return $uuid;
	
}
