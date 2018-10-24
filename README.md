# What is it?
This is collection of scripts that help me work with databases stack. 

If you have to move/copy few databases sometimes and you do a lot of mysqldump/mysql queries manually you can use scripts within this repository.

# How ir works?

### Prerequisites

To run these scripts you need following command available on your computer

    * mysql
    * mysqldump
    * jq
    * pv
    * gunzip


### 1. First you need to define databases in simple json file.

Save below content to `db1.json` and fill with your db params in `databases` section.

```json
{
    "options": {
    },

    "databases": [
        {
            "name": "first_db_name",
            "user": "first_db_user",
            "pass": "some_secret_password",
            "host": "host.mysql.server.com"
        },
        {
            "name": "second_db_name",
            "user": "second_db_user",
            "pass": "some_secret_password",
            "host": "host.mysql.server.com"
        },
        {
            "name": "third_db_name",
            "user": "third_db_user",
            "pass": "some_secret_password",
            "host": "host.mysql.server.com"
        }
    ]
}
```

### 2. Export databases

To export use the `export.sh` script.

Usage: `./export.sh configuration.json output_directory`

    * configuration.json - configuration file created in previous step.
    * output_directory - directory where output of export will be generated.


Example: 

    ```bash
    ./export db1.json db1_10_04_2018
    ```

Above command will crate 3 files in the `db1_10_04_2018` directory. One file per database. File name is equal to dbname.

### 3. Import databases

To import database use the `import.sh` script.

Usage: `./export.sh configuration.json input_directory`

    * configuration.json - configuration file created in first step.
    * input_directory - directory where you generated output with the `export.sh` script.

Example: 

    ```bash
    ./import.sh db1.json db1_10_04_2018
    ```


# Available options

    * lock_import - If this options is set to true you cannot import databases with active configuration.

    Example: 

    ```json
    {
        "options": {
            "lock_import": true
        },

        "databases": [
            "..."
        ]
    }