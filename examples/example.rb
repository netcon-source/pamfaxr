require 'rubygems'
require 'lib/pamfaxr'
require 'awesome_print'

PAMFAX_URI      = 'https://api.pamfax.biz/'
PAMFAX_USERNAME = 'username'
PAMFAX_PASSWORD = 'password'

# You may also specificy a custom :api_key and :api_secret, or it uses the default
pamfaxr = PamFaxr.new :base_uri => PAMFAX_URI,
                      :username => PAMFAX_USERNAME, 
                      :password => PAMFAX_PASSWORD

# Create a faxjob
faxjob = pamfaxr.create_fax_job
ap 'Creating a fax job'
ap '*'*10
ap faxjob

# Add a cover
covers = pamfaxr.list_available_covers
ap 'Listing available covers'
ap '*'*10
ap covers
ap 'Adding a cover'
ap '*'*10
ap pamfaxr.set_cover(covers['Covers']['content'][1]['id'], 'Foobar is here!')

ap 'Adding a remote file'
ap '*'*10
ap pamfaxr.add_remote_file('https://s3.amazonaws.com/pamfax-test/Tropo.pdf')

ap 'Adding a local file'
ap '*'*10
file = pamfaxr.add_file('examples/Tropo.pdf')
ap file

ap 'Removing a file'
ap '*'*10
ap pamfaxr.remove_file(file['FaxContainerFile']['file_uuid'])

ap 'Adding a recipient'
ap '*'*10
ap pamfaxr.add_recipient('+14155551212')

ap 'Adding a second recipient'
ap '*'*10
recipient = pamfaxr.add_recipient('+13035551212')
ap recipient

ap 'Removing a recipient'
ap '*'*10
ap pamfaxr.remove_file(recipient['FaxRecipient']['number'])

ap 'Listing a recipient'
ap '*'*10
ap pamfaxr.list_recipients

ap 'Listing associated fax files'
ap '*'*10
ap pamfaxr.list_fax_files

ap 'Checking state'
ap '*'*10
time = 0
loop do
  fax_state = pamfaxr.get_state
  ap fax_state
  converting = true
  break if fax_state['FaxContainer']['state'] == 'ready_to_send'
  sleep 2
  time += 2
  ap "#{time.to_s} seconds elapsed..."
end

ap 'Preview the fax'
ap '*'*10
ap pamfaxr.get_preview(faxjob['FaxContainer']['uuid'])

ap 'Sent the fax'
ap '*'*10
ap pamfaxr.send_fax

ap 'Sent the fax later'
ap '*'*10
ap pamfaxr.send_fax_later

ap 'Cloning the fax'
ap '*'*10
ap pamfaxr.clone_fax(faxjob['FaxContainer']['uuid'])