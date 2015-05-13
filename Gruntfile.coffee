module.exports = (grunt) ->

    # config
    grunt.initConfig

        pkg: grunt.file.readJSON("package.json")

        files:
            js:
                vendor: [
                    "public/vendor/angular/angular.min.js"
                    "public/vendor/angular/angular-cookies.min.js"
                ]
                src: ["public/src/js/**/*.js"]

            html:
                src: ["*.html"]


        # tasks

        clean:
            workspaces: ['public/dist', 'build', 'scrumwithme.*.zip']

        open:
            dev:
                path: "http://localhost:4000"

        jshint:
            src: "<%=files.js.src%>"

        concat:
            app_js:
                dest: 'public/dist/js/app.min.js'
                src: ["<%=files.js.src%>"]
            vendor_js:
                dest: 'public/dist/js/vendor.min.js'
                src: ["<%=files.js.vendor%>"]

        uglify:
            #options:
                #banner: "hi"

            dist:
                src: "<%=concat.app_js.dest %>"
                dest: "<%=concat.app_js.dest %>"


        copy:
            build:
                src: ["app/**", "public/**", ".ebextensions/**", "package.json", "!public/src/**", "!public/vendor/**"]
                dest: "build"
                expand: true

        compress:
            build:
                options:
                    archive: "<%=pkg.name%>." + grunt.template.today('yyyymmddHHMM') + ".zip"
                    mode: "zip"
                cwd: "build"
                src: ["**"]

        watch:
            options:
                livereload: true

            js:
                files: "<%=files.js.src%>"
                tasks: "concat:app_js"

            html:
                files: "<%=files.html.src%>"

        nodemon:
            dev:
                script: 'app/app.js'
                options:
                    watch: ['app']

        concurrent:
            options:
                logConcurrentOutput: true
            tasks: ['nodemon', 'watch']


    # load plugins
    require('matchdep').filterAll('grunt-*').forEach(grunt.loadNpmTasks);

    # create workflow
    grunt.registerTask 'default', ['concat', 'open', 'concurrent']
    grunt.registerTask 'build', ['clean', 'jshint', 'concat', 'uglify', 'copy:build', 'compress:build']



