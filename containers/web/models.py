# models.py


import datetime
from app import db


class Post(db.Model):
  __tablename__ = 'flockertab'
  intime = db.Column(db.DateTime, nullable=False)
  container_id = db.Column(db.String,length=90, primary_key=True)
  counter = db.Column(db.BigInteger, nullable=False)
    
  def __init__(self, counter,container_id):
    self.intime = datetime.datetime.now()
    self.container_id = container_id
    self.counter = counter