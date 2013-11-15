require 'spec_helper'
require 'nokogiri'

describe BlastOff::Template do
  let(:ipa) {
    double(
      'IPA',
      name: 'Foobar',
      bundle_identifier: 'com.example.Foobar',
      version: '2013',
      short_version: '1.0.0'
    )
  }
  let(:template) {
    BlastOff::Template.new(ipa)
  }

  describe '#html' do
    let(:doc) {
      Nokogiri::HTML(template.html('http://example.com/manifest.plist'))
    }
    let(:expected_install_url) {
      "itms-services://?action=download-manifest&url=http://example.com/manifest.plist"
    }

    it 'generate correct install button' do
      doc.at_css('.button')['href'].should eq expected_install_url
    end

    it 'generate correct version' do
      doc.at_css('h2').text.should eq 'Version: 1.0.0 (2013)'
    end

    it 'generate correct title' do
      doc.at_css('h1').text.should eq 'Foobar'
    end
  end

  describe '#manifest_plist' do
    let(:doc) {
      Nokogiri::XML(template.manifest_plist('http://example.com/Foobar.ipa'))
    }

    it 'generate correct bundle-identifier' do
      element = doc.
        at_xpath('//key[contains(text(),"bundle-identifier")]').
        next_element
      element.text.should eq 'com.example.Foobar'
    end

    it 'generate correct url' do
      element = doc.
        at_xpath('//key[contains(text(),"url")]').
        next_element
      element.text.should eq 'http://example.com/Foobar.ipa'
    end

    it 'generate correct bundle-version' do
      element = doc.
        at_xpath('//key[contains(text(),"bundle-version")]').
        next_element
      element.text.should eq '2013'
    end

    it 'generate correct title' do
      element = doc.
        at_xpath('//key[contains(text(),"title")]').
        next_element
      element.text.should eq 'Foobar'
    end
  end
end
