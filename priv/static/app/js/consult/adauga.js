$(document).ready(function () {
            $('#programariPicker').datetimepicker({
                pickTime: false,
                language: "ro"
                });
            $('#ruda').typeahead({
                source: function(request, process) {
                    $.ajax({
                        url:"/ruda/cauta/"+request,
                        dataType: "json",
                        success: function(data) {
                            return process(data.rude);}
                            })},
                        displayText: function(item) {
                            return item.nume; 
                            },
                            items:3,
                            delay: 2,
                            autoselect: true});
            var cautator = new Function("camp",
                   " $(camp).typeahead({\
                        source: function(request, process) {\
                                $.ajax({\
                                    url: '/icd/cauta/'+request,\
                                    dataType: 'json',\
                                    success: function(data){\
                                        return process(data.diagnostice);} \
                                    })},\
                            displayText: function (item) {\
                                return item.diagnostic; \
                                },\
                            items: 3,\
                            delay: 2,\
                            autoSelect: true,\
                            minLength: 3\
                                });");
            cautator("#search-icd");
            cautator("#boala");
            


                        
            $("#adaugaHeredocolaterale").on("submit", function(e){
                e.preventDefault();
                var submitButton = $(this);
                var form = $("#adaugaHeredocolaterale form");
                var formData = form.serialize();
                var pacientid = $(this).find('input[name=pacientid]').val();
                $.ajax({
                    url: "/pacient/adaugaHeredocolaterala/"+pacientid,
                    type: "POST",
                    data: formData,
                    error: function(data) {
                        console.log(data)
                    },
                    sucess: function(data) {
                            $("#adaugaHeredocolaterale").modal('hide');
                        }
                    })
                $("#adaugaHeredocolaterale").modal('hide')
                });
            $('#adaugaHeredocolaterale').on('show.bs.modal', function(event){
                    var button = $(event.relatedTarget)
                    var pacientid = button.data('pacientid')
                    var modal = $(this)
                    modal.find('input[name=pacientid]').val(pacientid)
                    });
                $('#data-diagnostic').datetimepicker({
                        pickTime:false,
                        language: "ro"
                        });
            });
