if (platform.session.role.name !== 'admin') {

    event.response.content.resource.forEach(function (record) {

        if (record.hasOwnProperty('emp_no')) {
            delete record.emp_no;
        }

        if (record.hasOwnProperty('birth_date')) {
            delete record.birth_date;
        }
    });
}
