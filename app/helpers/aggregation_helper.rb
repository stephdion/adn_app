module AggregationHelper
    def increment_on_key(aHash, aPropName)
        aPropName = getDefaultValue(aPropName)
        if aHash[aPropName] == nil
            aHash[aPropName] = 0
        end
        aHash[aPropName] += 1
        return aHash
    end

    def prepare_hash_for_frontend(aHash)
        hashToReturn = []
        aHash.each do |aName, aCount|
            hashToReturn.push(:name => "#{aName}", :count => "#{aCount}")
        end
        return hashToReturn
    end

    def sort_hash_reverse_value(aHashToSort)
        aHashToSort.sort_by {|_key, value| value}.reverse
    end


    :private
    def getDefaultValue(aPropName)
        if aPropName == nil || aPropName.length == 0
            aPropName = "Non spécifié"
        end
        aPropName
    end
end

