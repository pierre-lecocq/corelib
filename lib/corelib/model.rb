# File: model.rb
# Time-stamp: <2018-02-19 23:34:44>
# Copyright (C) 2018 Pierre Lecocq
# Description: Model class

module Corelib
  # Model class
  class Model
    include Propertize
    include Schematize

    # Initialize
    #
    # @param properties [Hash]
    def initialize(properties)
      update_properties properties
    end

    # Validate properties
    #
    # @param properties [Hash]
    #
    # @raise [StandardError] if one of the properties is not allowed by the schema
    #
    # @return [Hash] the curated properties
    def self.validate_properties(properties)
      valid_properties = {}
      authorized_columns = schema_attr(:columns)

      properties.each do |key, value|
        raise "Unknown '#{key}' property for model #{self}" \
          unless authorized_columns.include? key

        valid_properties[key] = format_value value, authorized_columns[key]
      end

      valid_properties
    end

    # Format value according to options
    #
    # @param value [Object]
    # @param options [Hash]
    #
    # @return [Object]
    def self.format_value(value, options = {})
      if options[:type] == Integer
        options[:formatter] = :to_i
      elsif options[:type] == Float
        options[:formatter] = :to_f
      elsif options[:type] == String
        options[:formatter] = :to_s
      end

      options.key?(:formatter) ? value.send(options[:formatter]) : value
    end

    # Create an object
    #
    # @param properties [Hash]
    #
    # @return [Model]
    def self.create(properties)
      columns, values, params = [], [], []
      valid_properties = validate_properties(properties)

      valid_properties.each do |key, value|
        columns << key
        params << value
        values << "$#{params.length}"
      end

      query = "INSERT INTO #{schema_attr(:table)}" \
              " (#{columns.join(', ')}) VALUES (#{values.join(', ')})" \
              " RETURNING #{schema_attr(:primary_key)}"

      result = Database.exec_params query, params
      primary_key_value = result.to_a.first[schema_attr(:primary_key).to_s]

      valid_properties[schema_attr(:primary_key)] = format_value primary_key_value,
                                                                 schema_attr(:columns)[schema_attr(:primary_key)]

      Log.info "Model #{self}##{primary_key_value} created successfully" \
        if included_modules.include? Loggable

      new valid_properties
    end

    # Update an object in the database and its properties
    #
    # @param properties [Hash]
    def update(properties)
      columns, params = [], []
      primary_key_value = property(schema_attr(:primary_key))
      valid_properties = self.class.validate_properties(properties)

      valid_properties.each do |key, value|
        params << value
        columns << "#{key} = $#{params.length}"
      end

      params << primary_key_value

      query = "UPDATE #{schema_attr(:table)} SET #{columns.join(', ')}" \
              " WHERE #{schema_attr(:primary_key)} = $#{params.length}"

      Database.exec_params query, params

      Log.info "Model #{self.class}##{primary_key_value} updated successfully" \
        if self.class.included_modules.include? Loggable

      update_properties valid_properties
    end

    # Delete an object and empty its properties
    def delete
      primary_key_value = property(schema_attr(:primary_key))

      query = "DELETE FROM #{schema_attr(:table)}" \
              " WHERE #{schema_attr(:primary_key)} = $1"

      Database.exec_params query, [primary_key_value]

      Log.info "Model #{self.class}##{primary_key_value} deleted successfully" \
        if self.class.included_modules.include? Loggable

      reset_properties
    end
  end
end
