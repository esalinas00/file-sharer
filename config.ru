Dir.glob('./{config,lib,models,queries,services,controllers}/init.rb').each do |file|
  require file
end

run FileSharingAPI
