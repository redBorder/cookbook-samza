# Cookbook Name:: samza
#
# Provider:: config
#

action :add do #Usually used to install and configure something
  begin
    rb_samza_bi_dir = new_resource.rb_samza_bi_dir
    config_dir = new_resource.config_dir
    log_dir = new_resource.log_dir
    rb_samza_bi_targz = "#{rb_samza_bi_dir}/app/rb-samza-bi.tar.gz"
    num_containers = new_resource.num_containers
    memory_per_container = new_resource.memory_per_container
    indexing_topics = new_resource.indexing_topics
    enrichment_topics = new_resource.enrichment_topics
    autoscaling_topics = new_resource.autoscaling_topics
    coordinator_replication_factor = new_resource.coordinator_replication_factor
    checkpoint_replication_factor = new_resource.checkpoint_replication_factor
    use_namespace = new_resource.use_namespace

    ##################################
    # Samza package installation
    ##################################

    yum_package "redborder-samza-bi" do
      action :upgrade
      flush_cache [:before]
    end

    ########################
    # Directories creation
    ########################
    directory config_dir do
      owner "root"
      group "root"
      mode "0755"
    end

    directory log_dir do
      owner "hadoop"
      group "hadoop"
      mode "0755"
    end

    ##########################
    # Retrieve databag data
    ##########################
    db_redborder = Chef::DataBagItem.load("passwords", "db_redborder") rescue db_redborder = {}
    if !db_redborder.empty?
      psql_uri = "#{db_redborder["hostname"]}:#{db_redborder["port"]}"
      psql_user = db_redborder["username"]
      psql_password = db_redborder["pass"]
    end
    kafka_topics = Chef::DataBagItem.load("backend", "kafka_topics") rescue kafka_topics = {}
    if !kafka_topics.empty?
      kafka_topics = kafka_topics["topics"]
    end
    ##################
    # Templates
    ##################

    #INDEXING
    template "#{config_dir}/indexing.properties" do
      source "rb-samza-bi_indexing.properties.erb"
      owner "root"
      group "root"
      mode 0644
      cookbook "samza"
      retries 2
      variables(:rb_samza_bi_targz => rb_samza_bi_targz,
                :num_containers => num_containers,
                :memory_per_container => memory_per_container,
                :indexing_topics => indexing_topics,
                :autoscaling_topics => autoscaling_topics,
                :coordinator_replication_factor => coordinator_replication_factor,
                :checkpoint_replication_factor => checkpoint_replication_factor,
                :kafka_topics => kafka_topics,
                :use_namespace => use_namespace)
    end
    execute 'start_indexing_task' do
      command "rb_samza.sh -e -t indexing"
      timeout 60
      ignore_failure true
      action :run
    end

    #ENRICHMENT
    template "#{config_dir}/enrichment.properties" do
      source "rb-samza-bi_enrichment.properties.erb"
      owner "root"
      group "root"
      mode 0644
      cookbook "samza"
      retries 2
      variables(:rb_samza_bi_targz => rb_samza_bi_targz,
                :num_containers => num_containers,
                :memory_per_container => memory_per_container,
                :enrichment_topics => enrichment_topics,
                :coordinator_replication_factor => coordinator_replication_factor,
                :checkpoint_replication_factor => checkpoint_replication_factor,
                :use_namespace => use_namespace,
                :psql_uri => psql_uri,
                :psql_user => psql_user,
                :psql_password => psql_password)
    end
    execute 'start_enrichment_task' do
      command "rb_samza.sh -e -t enrichment"
      timeout 60
      ignore_failure true
      action :run
    end

    Chef::Log.info("Samza cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    config_dir = new_resource.config_dir

    #####################
    # Package uninstall
    #####################
    #yum_package 'redborder-samza-bi' do
    #  action :remove
    #end

    #directory config_dir do
    #  action :delete
    #  recursive true
    #end

    Chef::Log.info("Samza cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end
