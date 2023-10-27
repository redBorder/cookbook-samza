# Cookbook Name:: example
#
# Resource:: config
#

actions :add, :remove
default_action :add

attribute :rb_samza_bi_dir, :kind_of => String, :default => "/usr/lib/samza/rb-samza-bi"
attribute :config_dir, :kind_of => String, :default => "/usr/lib/samza/rb-samza-bi/config"
attribute :log_dir, :kind_of => String, :default => "/var/log/rb-samza-bi"
attribute :num_containers, :kind_of => Integer, :default => 1
attribute :memory_per_container, :kind_of => Integer, :default => 2560
attribute :indexing_topics, :kind_of => Array, :default => [ "rb_flow_post", "rb_state_post",
		"rb_loc_post", "rb_monitor", "rb_event_post" ]
attribute :enrichment_topics, :kind_of => Array, :default => [ "rb_flow", "rb_state", 
		"rb_loc", "rb_event", "rb_nmsp", "rb_meraki", "rb_radius", "rb_pms" ]
attribute :autoscaling_topics, :kind_of => Array, :default => [ "rb_flow_post", "rb_event_post" ]
attribute :coordinator_replication_factor, :kind_of => Integer, :default => 1
attribute :checkpoint_replication_factor, :kind_of => Integer, :default => 1
attribute :use_namespace, :kind_of => [TrueClass, FalseClass] , :default => true
