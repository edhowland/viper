# snippet_collection_not_found.rb - exception SnippetCollectionNotFound

# SnippetCollectionNotFound raised for attempts to load a snippet collection, but no collection.json file exists.
class SnippetCollectionNotFound < RuntimeError
end
