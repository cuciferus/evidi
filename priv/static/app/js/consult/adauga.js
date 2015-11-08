$(document).ready(function () {
            $('#programariPicker').datetimepicker({
                pickTime: false,
                language: "ro"
                });
            $('#data-screening').datetimepicker({
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
            $('#screening-bun').change(function(event){
                var checkbox = event.target;
                if (checkbox.checked) {
                    $('#diagnostic-screening').val('NORMAL');
                    $('#diagnostic-screening').prop('disabled', true);

                } else { 
                    $('#diagnostic-screening').prop('disabled', false);
                    $('#diagnostic-screening').val('');
                }
            });
            $('#specialitate-medicala').typeahead({
                source: function(request, process){
                    $.ajax({
                        url:"/cauta/cauta_specialitate/"+request,
                        datatype:'json',
                        success: function(data){
                            console.log(data);
                            return process(data.specialitati);}
                    })},
                    displayText: function(item) {
                        return item.nume},
                    items:3,
                    delay:2,
                    autoSelect: true,
                    minLength:3
                });

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
            cautator("#diagnostic-screening");
            


                        
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
