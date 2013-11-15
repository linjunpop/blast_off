require 'cfpropertylist'

module BlastOff
  class Template
    def initialize(ipa_file)
      @ipa = ipa_file
    end

    def manifest_plist(ipa_file_url)
      {
        items: [
          assets: [
            {
              kind: 'software-package',
              url: ipa_file_url
            }
          ],
          metadata: {
            'bundle-identifier' => @ipa.bundle_identifier,
            'bundle-version' => @ipa.version,
            kind: 'software',
            title: @ipa.name
          }
        ]
      }.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
    end

    def html(manifest_plist_url)
      opts = OpenStruct.new({
        ipa: @ipa,
        manifest_plist_url: manifest_plist_url
      })
      template_file = File.join(File.dirname(File.expand_path(__FILE__)), 'template/index.html.erb')

      ::ERB.new(File.read(template_file)).result(opts.instance_eval {binding})
    end
  end
end
