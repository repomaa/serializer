require "./spec_helper"

describe ASR::Serializable do
  describe "#serialization_properties" do
    describe ASRA::Accessor do
      it "should use the value of the method" do
        properties = GetterAccessor.new.serialization_properties
        properties.size.should eq 1

        p = properties[0]

        p.name.should eq "foo"
        p.external_name.should eq "foo"
        p.value.should eq "FOO"
        p.skip_when_empty?.should be_false
        p.type.should eq String
        p.class.should eq GetterAccessor
      end
    end

    describe ASRA::AccessorOrder do
      describe :default do
        it "should used the order in which the properties were defined" do
          properties = Default.new.serialization_properties
          properties.size.should eq 6

          properties.map(&.name).should eq %w(a z two one a_a get_val)
          properties.map(&.external_name).should eq %w(a z two one a_a get_val)
        end
      end

      describe :alphabetical do
        it "should order the properties alphabetically by their name" do
          properties = Abc.new.serialization_properties
          properties.size.should eq 6

          properties.map(&.name).should eq %w(a a_a get_val one zzz z)
          properties.map(&.external_name).should eq %w(a a_a get_val one two z)
        end
      end

      describe :custom do
        it "should use the order defined by the user" do
          properties = Custom.new.serialization_properties
          properties.size.should eq 6

          properties.map(&.name).should eq %w(two z get_val a one a_a)
          properties.map(&.external_name).should eq %w(two z get_val a one a_a)
        end
      end
    end

    describe ASRA::Skip do
      it "should not include skipped properties" do
        properties = Skip.new.serialization_properties
        properties.size.should eq 1

        p = properties[0]

        p.name.should eq "one"
        p.external_name.should eq "one"
        p.value.should eq "one"
        p.skip_when_empty?.should be_false
        p.type.should eq String
        p.class.should eq Skip
      end
    end

    describe ASRA::ExclusionPolicy do
      describe :all do
        describe ASRA::Expose do
          it "should only return properties that are exposed" do
            properties = Expose.new.serialization_properties
            properties.size.should eq 1

            p = properties[0]

            p.name.should eq "name"
            p.external_name.should eq "name"
            p.value.should eq "Jim"
            p.skip_when_empty?.should be_false
            p.type.should eq String
            p.class.should eq Expose
          end
        end
      end

      describe :none do
        describe ASRA::Exclude do
          it "should only return properties that are not excluded" do
            properties = Exclude.new.serialization_properties
            properties.size.should eq 1

            p = properties[0]

            p.name.should eq "name"
            p.external_name.should eq "name"
            p.value.should eq "Jim"
            p.skip_when_empty?.should be_false
            p.type.should eq String
            p.class.should eq Exclude
          end
        end
      end
    end

    describe ASRA::Name do
      describe :serialize do
        it "should use the value in the annotation or property name if it wasnt defined" do
          properties = SerializedName.new.serialization_properties
          properties.size.should eq 3

          p = properties[0]

          p.name.should eq "my_home_address"
          p.external_name.should eq "myAddress"
          p.value.should eq "123 Fake Street"
          p.skip_when_empty?.should be_false
          p.type.should eq String
          p.class.should eq SerializedName

          p = properties[1]

          p.name.should eq "value"
          p.external_name.should eq "a_value"
          p.value.should eq "str"
          p.skip_when_empty?.should be_false
          p.type.should eq String
          p.class.should eq SerializedName

          p = properties[2]

          p.name.should eq "myZipCode"
          p.external_name.should eq "myZipCode"
          p.value.should eq 90210
          p.skip_when_empty?.should be_false
          p.type.should eq Int32
          p.class.should eq SerializedName
        end
      end
    end

    describe ASRA::SkipWhenEmpty do
      it "should use the value of the method" do
        properties = SkipWhenEmpty.new.serialization_properties
        properties.size.should eq 1

        p = properties[0]

        p.name.should eq "value"
        p.external_name.should eq "value"
        p.value.should eq "value"
        p.skip_when_empty?.should be_true
        p.type.should eq String
        p.class.should eq SkipWhenEmpty
      end
    end

    describe ASRA::VirtualProperty do
      it "should only return properties that are not excluded" do
        properties = VirtualProperty.new.serialization_properties
        properties.size.should eq 2

        p = properties[0]

        p.name.should eq "foo"
        p.external_name.should eq "foo"
        p.value.should eq "foo"
        p.skip_when_empty?.should be_false
        p.type.should eq String
        p.class.should eq VirtualProperty

        p = properties[1]

        p.name.should eq "get_val"
        p.external_name.should eq "get_val"
        p.value.should eq "VAL"
        p.skip_when_empty?.should be_false
        p.type.should eq String
        p.class.should eq VirtualProperty
      end
    end

    describe ASRA::IgnoreOnSerialize do
      it "should not include ignored properties" do
        properties = IgnoreOnSerialize.new.serialization_properties
        properties.size.should eq 1

        p = properties[0]

        p.name.should eq "name"
        p.external_name.should eq "name"
        p.value.should eq "Fred"
        p.skip_when_empty?.should be_false
        p.type.should eq String
        p.class.should eq IgnoreOnSerialize
      end
    end
  end
end