module Vidalia

  class InterfaceDefinition

    @@interfaces = []
    attr_reader :name, :parent, :interface

    # Create an Interface Definition
    #
    # Under the covers, the InterfaceDefinition will create or find the
    # associated Interface definition.  Any instantiated Interface will
    # be copied from this master copy.
    #
    # *Options*
    #
    # Takes two parameters:
    # Takes a hash as input where the current options are:
    # +name+:: (required) specifies the name of the Interface
    # Takes a block to be executed at initialization time
    #
    # *Example*
    #
    #   blog_api = Vidalia::InterfaceDefinition.new("Blog API") {
    #     @db_password = ENV['BLOG_DB_PASSWORD']
    #     @db_userid = ENV['BLOG_DB_PASSWORD']
    #     @db_ip = ENV['BLOG_DB_IP']
    #     @db_port = ENV['BLOG_DB_PORT']
    #   }
    #
    def initialize(opts = {}, &block)
      o = {
        :name => nil
      }.merge(opts)

      Vidalia::checkvar(o[:name],String,self.class.ancestors,"name")

      # It's OK to "define" an Interface that has already been defined
      unless @interface = Vidalia::InterfaceDefinition.find(o[:name])
        @interface = Vidalia::Interface.new(opts,&block)
        @@interfaces << @interface
      end
    end


    # Find an Interface by name
    #
    # *Options*
    #
    # Takes one parameter:
    # +name+:: (required) specifies the name of the Interface
    #
    # *Example*
    #
    #   $$$ Example needed $$$
    #
    def self.find(name)
      Vidalia::checkvar(name,String,self.class.ancestors,"name")
      interface = nil
      @@interfaces.each do |i|
        if i.name == name
          interface = i
        end
      end
      interface
    end
    
  end

end
