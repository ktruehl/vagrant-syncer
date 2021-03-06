module Vagrant
  module Syncer
    class Config < Vagrant.plugin(2, :config)

      attr_accessor \
        :disable_up_rsync,
        :force_listen_gem,
        :interval,
        :run_on_startup,
        :show_events,
        :ssh_args

      def initialize
        @disable_up_rsync = UNSET_VALUE
        @force_listen_gem = UNSET_VALUE
        @interval         = UNSET_VALUE
        @run_on_startup   = UNSET_VALUE
        @show_events      = UNSET_VALUE
        @ssh_args         = UNSET_VALUE
      end

      def finalize!
        @disable_up_rsync = false  if @disable_up_rsync == UNSET_VALUE
        @force_listen_gem = false  if @force_listen_gem == UNSET_VALUE
        @interval = 0.1          if @interval == UNSET_VALUE || @interval < 0.01
        @run_on_startup = true   if @run_on_startup == UNSET_VALUE
        @show_events = false     if @show_events == UNSET_VALUE

        if @ssh_args = UNSET_VALUE
          @ssh_args = [
            '-o StrictHostKeyChecking=no',
            '-o IdentitiesOnly=true',
            '-o UserKnownHostsFile=/dev/null',
          ]

          # ControlPaths seem to fail on Windows with Vagrant >= 1.8.0.
          # See: https://github.com/mitchellh/vagrant/issues/7046
          unless Vagrant::Util::Platform.windows?
            @ssh_args += [
              '-o ControlMaster=auto',
              "-o ControlPath=#{File.join(Dir.tmpdir, "ssh.#{rand(1000)}")}",
              '-o ControlPersist=10m'
            ]
          end
        end
      end

    end
  end
end
