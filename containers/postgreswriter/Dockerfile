FROM postgres
RUN mkdir /app/
COPY addRows.sh /app/
ENTRYPOINT [ "/app/addRows.sh" ]