require File.dirname(__FILE__) + '/../../spec_helper'
require 'ohm'
require 'database_cleaner/ohm/truncation'
require File.dirname(__FILE__) + '/ohm_examples'

module DatabaseCleaner
  module Ohm

    describe Truncation do

      before(:all) do
        ::Ohm.connect
        @test_db = ::Ohm.redis
      end

      before(:each) do
        ::Ohm.flush
      end

      def ensure_counts(expected_counts)
        sanity_check = expected_counts.delete(:sanity_check)
        begin
          expected_counts.each do |model_class, expected_count|
            model_class.count.should equal(expected_count), "#{model_class} expected to have a count of #{expected_count} but was #{model_class.count}"
          end
        rescue Spec::Expectations::ExpectationNotMetError => e
          raise !sanity_check ? e : Spec::ExpectationNotMetError::ExpectationNotMetError.new("SANITY CHECK FAILURE! This should never happen here: #{e.message}")
        end
      end

      def create_widget(attrs={})
        Widget.new({:name => 'some widget'}.merge(attrs)).save
      end

      def create_gadget(attrs={})
        Gadget.new({:name => 'some gadget'}.merge(attrs)).save.tap { |o| p o }
      end

      it "truncates all collections by default" do
        create_widget
        create_gadget
        ensure_counts(Widget => 1, Gadget => 1, :sanity_check => true)
        Truncation.new.clean
        ensure_counts(Widget => 0, Gadget => 0)
      end

      context "when collections are provided to the :only option" do
        it "only truncates the specified collections" do
          create_widget
          create_gadget
          ensure_counts(Widget => 1, Gadget => 1, :sanity_check => true)
          Truncation.new(:only => ['widgets']).clean
          ensure_counts(Widget => 0, Gadget => 1)
        end
      end

      context "when collections are provided to the :except option" do
        it "truncates all but the specified collections" do
          create_widget
          create_gadget
          ensure_counts(Widget => 1, Gadget => 1, :sanity_check => true)
          Truncation.new(:except => ['widgets']).clean
          ensure_counts(Widget => 1, Gadget => 0)
        end
      end

    end

  end
end
