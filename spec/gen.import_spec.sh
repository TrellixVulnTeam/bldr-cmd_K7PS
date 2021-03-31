Describe 'bldr gen.import'                                                                                           
  Include venv/bin/activate
  setup() {  
    setup_w_bldr gen.import_spec
  }
  cleanup() {  
    cleanup_dir
  }
  BeforeEach 'setup'
  AfterEach 'cleanup'
                                                                                       
  It 'Copies all files to Local Template'
    bldr gen.import $TEST_FILES/some_proj > /dev/null

    When call bldr gen.up
    The output should match pattern '*Creating*somefile*'
    The output should match pattern '*Creating*some_deep_file*'
    The path ./somefile should be exist 
    The path ./somedir/some_deep_dir/some_deep_file should be exist                                                                          
    
  End       

  It 'Warns to run `bldr gen.up`'
    When call bldr gen.import $TEST_FILES/some_proj
    The output should match pattern '*Import Complete.  Run `bldr gen.up` to update files*'
  End 

  It 'Imports to a module named `import.dirname`'
    When call bldr gen.import $TEST_FILES/some_proj
    The path ./.bldr/module/import.some_proj should be exist
    The output should match pattern '*Copying local *import.some_proj/local*'
  End

  It 'Converts files to templates'
    When call bldr gen.import $TEST_FILES/some_proj
    The path ./.bldr/config/config.toml should be exist
    The path ./.bldr/module/import.some_proj/local/net_code.bldr-j2.cs should be exist

    The path ./.bldr/module/import.some_proj/local/net_code.bldr-j2.cs contents should include "TheNewModule"
    The path ./.bldr/module/import.some_proj/local/net_code.bldr-j2.cs contents should include "ANotSoSimilarModule"
    The path ./.bldr/module/import.some_proj/local/net_code.bldr-j2.cs contents should include "ANew.Nested.OtherPlace.Function()"
    The output should match pattern '*Generating *import.some_proj/local/net_code.bldr-j2.cs*'
    
    #cat ./.bldr/module/import.some_proj/local/net_code.bldr-j2.cs
    #echo "gen.up\n"
    
    bldr gen.up > /dev/null
    The path ./net_code.cs contents should include "MyNewPlugableModule.CoolFunction(1,2,3)"
    
    #cat ./net_code.cs
    #The output should match pattern '*Copying local *import.some_proj/local*'
  End   
  It 'Creates a top-level module with --top'
    When call bldr gen.import --top $TEST_FILES/some_proj
    
    The path ./local/net_code.bldr-j2.cs should be exist

    The output should match pattern '*Generating *local/net_code.bldr-j2.cs*'
    
  End                                                                                                                                                                                                      
End    