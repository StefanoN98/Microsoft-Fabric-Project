bronze_customers:

let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "47f4b971-7b6b-4af9-8001-77745ea917c0"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "c9c219f7-14cc-47f2-8994-35d08101e937"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "bronze_customers", ItemKind = "Table"]}[Data]
in
  #"Navigation 2"


bronze_legacy_customers:

let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "47f4b971-7b6b-4af9-8001-77745ea917c0"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "c9c219f7-14cc-47f2-8994-35d08101e937"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "bronze_legacy_customers", ItemKind = "Table"]}[Data],

  // Safe deduplication: first check entire row, then check ok PK
  #"Removed exact duplicates" = Table.Distinct(#"Navigation 2"),

  // Standardization Country with exact match (not on a substring)
  #"Replaced value in Countries" = Table.ReplaceValue(#"Removed exact duplicates", "USA", "United States", Replacer.ReplaceValue, {"Country"}),

  // Placeholder Phone normalization
  #"Replaced value in Phone" = Table.ReplaceValue(#"Replaced value in Countries", "UNKNOWN", null, Replacer.ReplaceValue, {"Phone"}),

  // Manage mix format for Birth_Date
  #"Changed column type" = Table.TransformColumnTypes(#"Replaced value in Phone", {{"Birth_Date", type date}}, "it-IT"),

  // Cast Postal_Code as text (to manage initial zeros)
  #"Changed Postal Code type" = Table.TransformColumnTypes(#"Changed column type", {{"Postal_Code", type text}}),

  // Flag quality email
  #"Added has_valid_email" = Table.AddColumn(#"Changed Postal Code type", "has_valid_email", each [Email] <> null, type logical),
  #"Reordered columns" = Table.ReorderColumns(#"Added has_valid_email", {"Customer_Id", "First_Name", "Last_Name", "Gender", "Birth_Date", "Email", "has_valid_email", "Phone", "Country", "City", "State", "Postal_Code", "Registration_Date", "Customer_Segment", "Loyalty", "Active", "Language", "Marketing", "_ingestion_timestamp", "_source_file"})
in
  #"Reordered columns"
