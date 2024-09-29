Attribute VB_Name = "m_Test_DB_Code_Generator"
Option Compare Database

'' This module tests the functionality of the `Singularize` function,
'' which converts plural words to their singular form.

Function Test_Singularize_ies() As Boolean
    '' Tests the `Singularize` function with a word ending in "ies".
    '' Returns True if "Countries" is correctly singularized to "Country", False otherwise.
    
    Test_Singularize_ies = Singularize("Countries") = "Country"
End Function

Function Test_Singularize_ses() As Boolean
    '' Tests the `Singularize` function with a word ending in "ses".
    '' Returns True if "Classes" is correctly singularized to "Class", False otherwise.
    
    Test_Singularize_ses = Singularize("Classes") = "Class"
End Function

Function Test_Singularize_ches() As Boolean
    '' Tests the `Singularize` function with a word ending in "ches".
    '' Returns True if "Switches" is correctly singularized to "Switch", False otherwise.
    
    Test_Singularize_ches = Singularize("Switches") = "Switch"
End Function

Function Test_Singularize_shes() As Boolean
    '' Tests the `Singularize` function with a word ending in "shes".
    '' Returns True if "Lashes" is correctly singularized to "Lash", False otherwise.
    
    Test_Singularize_shes = Singularize("Lashes") = "Lash"
End Function

Function Test_Singularize_xes() As Boolean
    '' Tests the `Singularize` function with a word ending in "xes".
    '' Returns True if "Boxes" is correctly singularized to "Box", False otherwise.
    
    Test_Singularize_xes = Singularize("Boxes") = "Box"
End Function

Function Test_Singularize_zes() As Boolean
    '' Tests the `Singularize` function with a word ending in "zes".
    '' Returns True if "Buzzes" is correctly singularized to "Buzz", False otherwise.
    
    Test_Singularize_zes = Singularize("Buzzes") = "Buzz"
End Function

Function Test_Singularize_ia() As Boolean
    '' Tests the `Singularize` function with a word ending in "ia".
    '' Returns True if "Media" is correctly singularized to "Medium", False otherwise.
    
    Test_Singularize_ia = Singularize("Media") = "Medium"
End Function

Function Test_Singularize_criteria() As Boolean
    '' Tests the `Singularize` function with the irregular word "criteria".
    '' Returns True if "criteria" is correctly singularized to "Criterion", False otherwise.
    
    Test_Singularize_criteria = Singularize("criteria") = "Criterion"
End Function

Function Test_Singularize_XXX() As Boolean
    '' Tests the `Singularize` function with a custom irregular word "XXXs".
    '' Returns True if "XXXs" is correctly singularized to "XXX", False otherwise.
    
    Test_Singularize_XXX = Singularize("XXXs") = "XXX" ' Test irregular mechanism
End Function

