#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);
use Data::Dumper;

use JSON; # to install, # sudo cpan JSON
$json_engine	= JSON->new->allow_nonref;
$server = "my.velantro.com";
$DEBUG  = 1;
#$data = md5_hex('admin@velantro.com:admin5');
#$realm = "sip.velantro.com";
$data = md5_hex('zhongxiang721@gmail.com:admin5');
$realm = "32nmhrh.my.velantro.com";
#$data = md5_hex('admin@samsung.com:admin5');
#$realm = "tbauzst.my.velantro.com";
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

#https://my.velantro.com/v2/accounts/ab7052dfd033ce8c7a0f1d2bad49ca97/cdrs/interaction?created_from=63653616000&created_to=63653702399&page_size=50&_=1486450745345

&query('GET', "v2/accounts/$account_id/cdrs/interaction?created_from=63653616000&created_to=63653702399&page_size=50&_=1486450745345");

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
		$cmd = qq`curl  -X $method 'http://$server:8000/$path' -H "Content-Type:application/json" -H "X-Auth-Token: $auth_token" -d '$data'`;
	} else {
		$cmd = qq`curl  'http://$server:8000/$path' -H "Content-Type:application/json" -H "X-Auth-Token: $auth_token"`;
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